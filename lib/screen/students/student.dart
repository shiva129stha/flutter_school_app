import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_school_app/screen/first_main/login.dart';
import 'package:flutter_school_app/data/model/model.dart';

class Student extends StatefulWidget {
  final String url;
  final String name;
  final String email;
  final String id;

  const Student({
    super.key,
    required this.id,
    required this.url,
    required this.name,
    required this.email,
  });

  @override
  _StudentState createState() => _StudentState();
}

class _StudentState extends State<Student> {
  late FirebaseMessaging _messaging;
  UserModel loggedInUser = UserModel(role: '');

  @override
  void initState() {
    super.initState();
    _setupFirebaseMessaging();
    _fetchUserData();
  }

  // Set up Firebase Messaging
  Future<void> _setupFirebaseMessaging() async {
    _messaging = FirebaseMessaging.instance;

    // Request notification permissions (for iOS)
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // Get the device token
    String? token = await _messaging.getToken();
    print("FCM Token: $token");

    // Save or update the device token in Firestore
    if (token != null) {
      await FirebaseFirestore.instance.collection('device_tokens').doc(token).set({
        'token': token,
        'userId': widget.id, // Optional: associate with user ID if needed
      }, SetOptions(merge: true));
    }

    // Subscribe to a topic (e.g., 'students')
    await _messaging.subscribeToTopic('students');

    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showNotificationDialog(
            message.notification!.title, message.notification!.body);
      }
    });

    // Handle when the app is opened via a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
    });
  }

  // Show notification dialog
  void _showNotificationDialog(String? title, String? body) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title ?? 'No Title'),
        content: Text(body ?? 'No Body'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Fetch user data from Firestore
  Future<void> _fetchUserData() async {
    if (widget.id.isEmpty) {
      print('Error: The student ID is empty.');
      return; // Exit the function early if ID is empty
    }

    try {
      print('Fetching user data for ID: ${widget.id}');
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("users").doc(widget.id).get();
      if (userDoc.exists) {
        loggedInUser = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
        setState(() {
          // Ensure state variables are properly used
        });
      } else {
        print('No user found with the provided ID.');
      }
    } catch (e) {
      print('Failed to fetch user data: $e');
    }
  }

  Future<void> _refreshPosts() async {
    // Force a refresh of the data (no-op for this example, but could be used for more advanced refresh logic)
    setState(() {});
  }

  Stream<QuerySnapshot> get _postsStream {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('updatedAt', descending: true) // Order by date in descending order
        .snapshots()
        .handleError((error) {
          print('Stream error: $error');
        });
  }

  // Function to check if the text is a URL
  bool isValidURL(String url) {
    final Uri uri = Uri.tryParse(url) ?? Uri();
    return uri.hasScheme && uri.hasAuthority;
  }

  // Function to determine the URL type
  String getUrlType(String url) {
    if (url.endsWith('.pdf')) return 'pdf';
    if (url.endsWith('.doc') || url.endsWith('.docx')) return 'doc';
    if (url.endsWith('.ppt') || url.endsWith('.pptx')) return 'ppt';
    if (url.endsWith('.xls') || url.endsWith('.xlsx')) return 'xls';
    if (url.endsWith('.txt')) return 'txt';
    if (url.contains('facebook.com')) return 'facebook';
    if (url.contains('twitter.com')) return 'twitter';
    if (url.contains('youtube.com')) return 'youtube';
    if (url.contains('instagram.com')) return 'instagram';
    if (url.contains('linkedin.com')) return 'linkedin';
    if (url.contains('github.com')) return 'github';
    if (url.contains('wikipedia.org')) return 'wikipedia';
    if (url.contains('drive.google.com')) return 'google_drive';
    if (url.contains('maps.google.com')) return 'google_maps';
    // Add more URL type checks as needed
    return 'default';
  }

  // Function to handle showing options for both text and URL
  void _showTextOptions(BuildContext context, String text) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.copy),
                title: Text('Copy'),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: text));
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Text copied to clipboard'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.share),
                title: Text('Share'),
                onTap: () {
                  try {
                    Share.share(text);
                  } catch (e) {
                    print('Error while sharing: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to share the text'),
                      ),
                    );
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Teachers Posts",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.tealAccent,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPosts,
        child: StreamBuilder(
          stream: _postsStream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              print('Snapshot error: ${snapshot.error}');
              return const Center(
                child: Text(
                  "Something went wrong",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'No posts available',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }

            return Container(
              color: Colors.grey[100],
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (_, index) {
                  var doc = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  final content = doc['title'] ?? '';

                  return GestureDetector(
                    onLongPress: () {
                      _showTextOptions(context, content);
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doc['userName'] ?? 'Unknown Name',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            Text(
                              doc['email'] ?? 'Unknown email',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            isValidURL(content)
                                ? InkWell(
                                    onTap: () async {
                                      try {
                                        await launch(content, forceSafariVC: false);
                                      } catch (e) {
                                        print('Failed to launch $content: $e');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Could not open the link.'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(
                                      content,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  )
                                : Text(
                                    content,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                          ],
                        ),
                        subtitle: Text(
                          doc['updatedAt'] != null
                              ? 'Updated on: ${formatDate(doc['updatedAt'])}'
                              : 'No date available',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.share),
                          onPressed: () {
                            Share.share('${doc['title']} - ${doc['description']}');
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  // Format date to a readable string with time
  String formatDate(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'No date available';
    }
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd MMM yyyy – hh:mm a').format(dateTime); // Updated format
  }
}

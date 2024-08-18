import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_school_app/login.dart';
import 'package:flutter_school_app/model.dart';
import 'package:intl/intl.dart';

class Student extends StatefulWidget {
  final String url;
  final String name;
  final String email;
  String id;

  Student({
    super.key,
    required this.id,
    required this.url,
    required this.name,
    required this.email,
  });

  @override
  _StudentState createState() => _StudentState(id: id);
}

class _StudentState extends State<Student> {
  String id;
  var rooll;
  var emaill;
  UserModel loggedInUser = UserModel(role: '');
  late FirebaseMessaging _messaging;

  _StudentState({required this.id});

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
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // Get the device token
    String? token = await _messaging.getToken();
    print("FCM Token: $token");

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
        title: Text(title ?? ''),
        content: Text(body ?? ''),
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
// Fetch user data from Firestore
Future<void> _fetchUserData() async {
  if (id.isEmpty) {
    print('Error: The student ID is empty.');
    return; // Exit the function early if ID is empty
  }

  try {
    print('Fetching user data for ID: $id');
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("users").doc(id).get();
    if (userDoc.exists) {
      loggedInUser = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      setState(() {
        emaill = loggedInUser.email ?? '';
        rooll = loggedInUser.wrool ?? '';
      });
    } else {
      print('No user found with the provided ID.');
    }
  } catch (e) {
    print('Failed to fetch user data: $e');
  }
}


  final Stream<QuerySnapshot> _postsStream =
      FirebaseFirestore.instance.collection('posts').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Student",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _postsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
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
                var doc = snapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      doc['title'] ?? 'No title',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
                    trailing:
                        Icon(Icons.arrow_forward_ios, color: Colors.orange),
                    onTap: () {},
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    // Log out user
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginPageScreen(),
      ),
    );
  }

  String formatDate(dynamic date) {
    // Format Firestore Timestamp
    if (date is Timestamp) {
      final formatter = DateFormat('yyyy-MM-dd HH:mm');
      return formatter.format(date.toDate());
    }
    return 'No date available';
  }
}

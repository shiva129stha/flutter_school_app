import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_school_app/screen/teacher/addpost.dart';
import 'package:flutter_school_app/screen/teacher/editpost.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  PostsState createState() => PostsState();
}

class PostsState extends State<Posts> {
  final Stream<QuerySnapshot> _postsStream =
      FirebaseFirestore.instance
          .collection('posts')
          .orderBy('createdAt', descending: true) // Sort by createdAt in descending order
          .snapshots();

  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddPost(),
            ),
          );
        },
        backgroundColor: Colors.tealAccent,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Posts',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.tealAccent,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPosts,
        child: StreamBuilder<QuerySnapshot>(
          stream: _postsStream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error: ${snapshot.error}",
                  style: const TextStyle(color: Colors.red),
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

            // Extract the document IDs to fetch user details in one batch
            List<String> userIds = snapshot.data!.docs.map((doc) => doc['createdBy'] as String).toSet().toList();

            return FutureBuilder<List<DocumentSnapshot>>(
              future: Future.wait(
                userIds.map((userId) =>
                  FirebaseFirestore.instance.collection('users').doc(userId).get(),
                ),
              ),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (userSnapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error: ${userSnapshot.error}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (!userSnapshot.hasData) {
                  return const Center(
                    child: Text(
                      'User data not available',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                Map<String, Map<String, dynamic>> usersData = {
                  for (var userDoc in userSnapshot.data!)
                    userDoc.id: userDoc.data() as Map<String, dynamic>
                };

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (_, index) {
                    var doc = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    String createdAtText = 'No date available';
                    if (doc.containsKey('createdAt') && doc['createdAt'] is Timestamp) {
                      var createdAt = doc['createdAt'] as Timestamp;
                      createdAtText = 'Created on: ${formatDate(createdAt)}';
                    }

                    bool isCreator = doc['createdBy'] == currentUser?.uid;

                    var userDoc = usersData[doc['createdBy']] ?? {};
                    String userName = userDoc['name'] ?? 'Unknown';
                    String userEmail = userDoc['email'] ?? 'No email available';

                    return GestureDetector(
                      onLongPress: () {
                        _showTextOptions(
                          context,
                          doc['title'] ?? '',
                          isCreator,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditPost(
                                  docid: snapshot.data!.docs[index], // Pass the document ID
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
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
                                userName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              Text(
                                userEmail,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              isValidURL(doc['title'])
                                  ? InkWell(
                                      onTap: () async {
                                        try {
                                          await launch(doc['title'], forceSafariVC: false);
                                        } catch (e) {
                                          print('Failed to launch ${doc['title']}: $e');
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Could not open the link.'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      },
                                      child: Text(
                                        doc['title'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      doc['title'] ?? '',
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
                            icon: const Icon(Icons.share),
                            onPressed: () {
                              Share.share('${doc['title']} - ${doc['description']}');
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
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

  // Function to check if the text is a URL
  bool isValidURL(String url) {
    final Uri uri = Uri.tryParse(url) ?? Uri();
    return uri.hasScheme && uri.hasAuthority;
  }

  // Function to handle showing options for both text and URL
  void _showTextOptions(
    BuildContext context,
    String text,
    bool isCreator,
    VoidCallback onEdit,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('Copy'),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: text));
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Text copied to clipboard'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                onTap: () {
                  try {
                    Share.share(text);
                  } catch (e) {
                    print('Error while sharing: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to share the text'),
                      ),
                    );
                  }
                  Navigator.of(context).pop();
                },
              ),
              if (isCreator) // Show edit option only if user is the creator
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit Post'),
                  onTap: () {
                    Navigator.of(context).pop(); // Close the bottom sheet
                    onEdit(); // Navigate to the edit screen
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _refreshPosts() async {
    // Force a refresh of the data (no-op for this example, but could be used for more advanced refresh logic)
    setState(() {});
  }
}

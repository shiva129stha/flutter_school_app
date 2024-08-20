import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_school_app/screen/students/formatdate.dart';
import 'package:flutter_school_app/screen/teacher/addpost.dart';
import 'package:flutter_school_app/screen/teacher/editpost.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  PostsState createState() => PostsState();
}

class PostsState extends State<Posts> {
  final Stream<QuerySnapshot> _postsStream =
      FirebaseFirestore.instance.collection('posts').snapshots();

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
        title: const Text('Posts'),
        backgroundColor: Colors.tealAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
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
                    onTap: () {
                      if (isCreator) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditPost(docid: snapshot.data!.docs[index]),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('You can only edit your own posts'),
                          ),
                        );
                      }
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          doc['title'] ?? 'No title',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
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
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              userName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                              userEmail,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
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
    );
  }
}

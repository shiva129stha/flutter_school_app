import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_school_app/students/formatdate.dart';
// import 'package:flutter_school_app/students/formatdate.dart';
import 'package:flutter_school_app/teacher/addpost.dart';
import 'package:flutter_school_app/teacher/editpost.dart';


class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  PostsState createState() => PostsState();
}

class PostsState extends State<Posts> {
  final Stream<QuerySnapshot> _postsStream =
      FirebaseFirestore.instance.collection('posts').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) =>  AddPost()), // Navigate to AddPost screen
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.orange, // Accent color for the button
      ),
      appBar: AppBar(
        title: const Text('Posts'),
        backgroundColor: Colors.orange, // Matching AppBar color with FloatingActionButton
      ),
      body: StreamBuilder(
        stream: _postsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.red)),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No posts available', style: TextStyle(fontSize: 18, color: Colors.grey)),
            );
          }

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

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditPost(docid: snapshot.data!.docs[index]),
                    ),
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
                    title: Text(
                      doc['title'] ?? 'No title',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    subtitle: Text(
                      createdAtText,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

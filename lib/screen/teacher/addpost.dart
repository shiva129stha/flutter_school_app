import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final TextEditingController _titleController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> _addPost() async {
  final String title = _titleController.text.trim();
  final User? currentUser = _auth.currentUser;

  if (title.isNotEmpty && currentUser != null) {
    try {
      // Fetch the user's name and email from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      String userName = userDoc['name'] ?? 'Unknown'; // Handle missing name
      String userEmail = userDoc['email'] ?? 'No email available'; // Handle missing email

      // Add the post with the user's details
      await FirebaseFirestore.instance.collection('posts').add({
        'title': title,
        'createdBy': currentUser.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'userName': userName,
        'email': userEmail, // Add user email to the post
      });

      // Show success message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post added successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add post: $e')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Title cannot be empty')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Post Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addPost,
              child: const Text('Add Post'),
            ),
          ],
        ),
      ),
    );
  }
}

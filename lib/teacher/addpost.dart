import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final TextEditingController _titleController = TextEditingController();

  Future<void> _addPost() async {
    final String title = _titleController.text.trim();

    if (title.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('posts').add({
          'title': title,
          'createdAt': FieldValue.serverTimestamp(),
           'updatedAt': FieldValue.serverTimestamp(), // Store current server time
        });

        // Optionally, show a success message or navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post added successfully')),
        );

        Navigator.pop(context); // Go back to the previous screen
      } catch (e) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add post: $e')),
        );
      }
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

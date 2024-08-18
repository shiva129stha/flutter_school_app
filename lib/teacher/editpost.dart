import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_school_app/students/formatdate.dart';

class EditPost extends StatefulWidget {
  final DocumentSnapshot docid;

  const EditPost({Key? key, required this.docid}) : super(key: key);

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  late TextEditingController _titleController;
  String createdAtText = 'No date available';
  String updatedAtText = 'No date available';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.docid['title'] ?? '');

    // Format and set the createdAt date
    final createdAt = widget.docid['createdAt'];
    if (createdAt is Timestamp) {
      createdAtText = 'Created on: ${formatDate(createdAt)}';
    }

    // Format and set the updatedAt date
    final updatedAt = widget.docid['updatedAt'];
    if (updatedAt is Timestamp) {
      updatedAtText = 'Last updated on: ${formatDate(updatedAt)}';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _updatePost() async {
    final String title = _titleController.text.trim();

    if (title.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.docid.id)
            .update({
              'title': title,
              'updatedAt': FieldValue.serverTimestamp(), // Update timestamp on modification
            });

        // Fetch the updated document to get the new 'updatedAt' timestamp
        DocumentSnapshot updatedDoc = await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.docid.id)
            .get();

        final updatedAt = updatedDoc['updatedAt'];
        if (updatedAt is Timestamp) {
          setState(() {
            updatedAtText = 'Last updated on: ${formatDate(updatedAt)}';
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post updated successfully')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update post: $e')),
        );
      }
    }
  }

  Future<void> _deletePost() async {
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.docid.id)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post deleted successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete post: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              createdAtText,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            Text(
              updatedAtText,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Post Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _updatePost,
                  child: const Text('Update Post'),
                ),
                ElevatedButton(
                  onPressed: _deletePost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Red color for delete button
                  ),
                  child: const Text('Delete Post'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

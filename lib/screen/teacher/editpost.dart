import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_school_app/screen/students/formatdate.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditPost extends StatefulWidget {
  final DocumentSnapshot docid;

  const EditPost({super.key, required this.docid,});

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  late TextEditingController _titleController;
  String createdAtText = 'No date available';
  String updatedAtText = 'No date available';

  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.docid['title'] ?? '');

    final createdAt = widget.docid['createdAt'];
    if (createdAt is Timestamp) {
      createdAtText = 'Created on: ${formatDate(createdAt)}';
    }

    final updatedAt = widget.docid['updatedAt'];
    if (updatedAt is Timestamp) {
      updatedAtText = 'Last updated on: ${formatDate(updatedAt)}';
    }

    // Check if the current user is the creator of the post
    if (widget.docid['createdBy'] != currentUser?.uid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You can only edit your own posts'),
        ),
      );
      Navigator.pop(context);
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
              'updatedAt': FieldValue.serverTimestamp(),
            });

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

  Future<void> _confirmDeletePost() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to close
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Post'),
          content: const Text('Are you sure you want to delete this post? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text('Yes, Delete'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                _deletePost(); // Proceed with delete action
              },
            ),
          ],
        );
      },
    );
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
                  onPressed: _confirmDeletePost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
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

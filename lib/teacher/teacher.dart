import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../login.dart';
import '../model.dart';
import '../students/posts.dart';
import '../students/StudentList.dart';

class Teacher extends StatefulWidget {
  final String id;
  const Teacher({Key? key, required this.id}) : super(key: key);

  @override
  _TeacherState createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
  late String id;
  late String email;
  late String role;
  bool _isLoading = true;
  UserModel loggedInUser = UserModel(role: '');

  @override
  void initState() {
    super.initState();
    id = widget.id;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .get();

      setState(() {
        loggedInUser = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
        email = loggedInUser.email ?? 'No email';
        role = loggedInUser.role ?? 'No role';
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginPageScreen(),
        ),
      );
    } catch (e) {
      print('Error signing out: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Teacher Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo[900],
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildDashboardButton(
                    context,
                    icon: Icons.people,
                    text: "List of Students",
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const StudentList(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildDashboardButton(
                    context,
                    icon: Icons.post_add,
                    text: "Manage Posts",
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const Posts(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildDashboardButton(BuildContext context,
      {required IconData icon, required String text, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 28),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.indigo[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
      ),
    );
  }
}

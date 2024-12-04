// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_school_app/screen/students/StudentList.dart';
import 'package:flutter_school_app/screen/students/posts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_school_app/screen/navigation/home_page.dart';
import 'package:flutter_school_app/screen/drawer/navbar.dart';
import 'package:flutter_school_app/screen/navigation/school_dashboard_screen.dart';
import 'package:flutter_school_app/screen/navigation/teacher_phone_screen.dart';

class DashboardScreenTeacher extends StatefulWidget {
  final String id;

  DashboardScreenTeacher({
    super.key,
    required this.id,
  });

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  State<DashboardScreenTeacher> createState() => _DashboardScreenTeacherState();
}

class _DashboardScreenTeacherState extends State<DashboardScreenTeacher> {
  int currentIndex = 0;
  final screens = [
    const SchoolDashboardScreen(),
    const HomePage(),
    const Posts(),
    const StudentList(),
    const TeacherPhoneScreen(),
  ];

  Future<DocumentSnapshot> _getUserData() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.id)
        .get();
  }

  // Helper method to generate a color based on the user's name
  Color _generateBackgroundColor(String name) {
    final colors = [
      Colors.redAccent,
      Colors.black,
      Colors.greenAccent,
      Colors.blueAccent,
      Colors.pinkAccent,
      Colors.purpleAccent,
      Colors.tealAccent,
    ];
    final index = name.isNotEmpty ? name.codeUnitAt(0) % colors.length : 0;
    return colors[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: (currentIndex == 2 || currentIndex == 3|| currentIndex == 4)
          ? null // Hide AppBar on the Student sc
          : AppBar(
              title: FutureBuilder<DocumentSnapshot>(
                future: _getUserData(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }

                  if (snapshot.hasData && !snapshot.data!.exists) {
                    return const Text("User not found");
                  }

                  if (!snapshot.hasData) {
                    return const Text("Loading...");
                  }

                  var userData = snapshot.data!;
                  String name = userData['name'] ?? 'No name';
                  String email = userData['email'] ?? 'No email';
                  String initial =
                      name.isNotEmpty ? name[0].toUpperCase() : "?";
                  Color backgroundColor = _generateBackgroundColor(name);

                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: backgroundColor,
                        child: Text(
                          initial,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            email,
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              backgroundColor: Colors.teal,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1.0),
                child: Container(
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
            ),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "To-Do",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add),
            label: "Add Posts",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Student",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            label: "Contact",
          ),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_school_app/students/student.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_school_app/screen/navigation/home_page.dart';
import 'package:flutter_school_app/screen/drawer/navbar.dart';
import 'package:flutter_school_app/screen/navigation/school_dashboard_screen.dart';
import 'package:flutter_school_app/screen/navigation/teacher_phone_screen.dart';

class DashboardScreenStudent extends StatefulWidget {
  final String url;
  final String name;
  final String email;
  String id;

  DashboardScreenStudent({
    super.key,
    required this.id,
    required this.url,
    required this.name,
    required this.email,
  });

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  State<DashboardScreenStudent> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreenStudent> {
  int currentIndex = 0;
  final screens = [
    const SchoolDashboardScreen(),
    const HomePage(),
    Student(id: '', url: '', name: '', email: ''),
    const TeacherPhoneScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: Row(
          children: [
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  user!.displayName!,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  user.email!,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.orange,
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
        selectedItemColor: Colors.orange,
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
            icon: Icon(Icons.school),
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

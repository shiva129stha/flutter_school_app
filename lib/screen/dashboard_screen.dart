import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_school_app/screen/home_page.dart';
import 'package:flutter_school_app/screen/navbar.dart';
import 'package:flutter_school_app/screen/school_dashboard_screen.dart';
import 'package:flutter_school_app/screen/teacher_phone_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;
  final screens = const [
    SchoolDashboardScreen(),
    HomePage(),
    TeacherPhoneScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user!.photoURL!),
              radius: 17,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  user.displayName!,
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold), // Customize title style
                ),
                Text(
                  user.email!,
                  style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey), // Customize subtitle style
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.red,

        // actions: <Widget>[
        //   ElevatedButton.icon(
        //     onPressed: () {
        //       AuthRepository()
        //           .signOutWithGoogle()
        //           .whenComplete(Navigator.of(context).pop);
        //     },
        //     icon: Icon(Icons.logout),
        //     label: Text("Log Out"),
        //   ),
        // ],
        // centerTitle: true,
        //  automaticallyImplyLeading: false,
      ),
      body: Center(child: screens[currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        // backgroundColor: Colors.purple,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "Home",
            // backgroundColor: Colors.amber
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
            ),
            label: "Add",
            // backgroundColor: Colors.indigo
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.phone,
            ),
            label: "Phone",
            // backgroundColor: Colors.indigo
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

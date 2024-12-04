// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_school_app/screen/drawer/calendar_page.dart';
import 'package:flutter_school_app/screen/first_main/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  Stream<DocumentSnapshot>? _userStream;

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userStream = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots();
    }
  }

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

  // Extract initials from the user's name
  String getInitials(String name) {
    List<String> nameParts = name.split(" ");
    String initials = "";
    if (nameParts.isNotEmpty) {
      initials = nameParts[0][0].toUpperCase(); // First name initial
      if (nameParts.length > 1) {
        initials += nameParts[1][0].toUpperCase(); // Last name initial
      }
    }
    return initials;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _userStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Drawer(
            child: Center(
              child: Text('Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red)),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Drawer(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Drawer(
            child: Center(
              child:
                  Text('User not found', style: TextStyle(color: Colors.red)),
            ),
          );
        }

        var userData = snapshot.data!;
        String name = userData['name'] ?? 'No Name';
        String email = userData['email'] ?? 'No Email';
        String initials = getInitials(name);
        Color backgroundColor = _generateBackgroundColor(name);

        return Drawer(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  accountEmail: Text(
                    email,
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.white70,
                    ),
                  ),
                  currentAccountPicture: CircleAvatar(
                    radius: 45,
                    backgroundColor: backgroundColor,
                    child: Text(
                      initials,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.transparent, // Use gradient for background
                  ),
                ),
                _createDrawerItem(
                  icon: Icons.message,
                  text: 'Messages',
                  onTap: () {
                    // Handle navigation
                  },
                  color: Colors.lightBlueAccent,
                ),
                _createDrawerItem(
                  icon: Icons.account_circle,
                  text: 'Profile',
                  onTap: () {
                    // Handle navigation
                  },
                  color: Colors.cyanAccent,
                ),
                _createDrawerItem(
                  icon: Icons.calendar_today,
                  text: 'Calendar',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => NepaliCalendarPage(),
                      ),
                    );
                  },
                  color: Colors.orangeAccent,
                ),
                _createDrawerItem(
                  icon: Icons.settings,
                  text: 'Settings',
                  onTap: () {
                    // Handle navigation
                  },
                  color: Colors.tealAccent,
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.white54,
                ),
                _createDrawerItem(
                  icon: Icons.logout,
                  text: 'Log Out',
                  onTap: () {
                    _logout(context);
                  },
                  color: Colors.redAccent,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _createDrawerItem({
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,
    required Color color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title:
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
      onTap: onTap,
    );
  }

  Future<void> _logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginPageScreen(),
      ),
    );
  }
}

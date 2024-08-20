import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_school_app/screen/dashboard_screen_stu.dart';
import 'package:flutter_school_app/screen/dashboard_screen_teacher.dart';

import '../../../../data/model/model.dart';

class HomePageController extends StatefulWidget {
  const HomePageController({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageController> {
  @override
  Widget build(BuildContext context) {
    return const Control();
  }
}

class Control extends StatefulWidget {
  const Control({super.key});

  @override
  _ControState createState() => _ControState();
}

class _ControState extends State<Control> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel(role: '');
  String? rooll;
  String? emaill;
  String? id;
  String? gender;
  bool isLoading = true; // Add a loading state

  @override
  void initState() {
    super.initState();
    if (user != null) {
      fetchUserData();
    } else {
      // Handle the case when user is null, e.g., navigate to login page
      print('User is not logged in');
    }
  }

  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> value = await FirebaseFirestore
          .instance
          .collection("users")
          .doc(user!.uid)
          .get();

      if (value.exists) {
        setState(() {
          loggedInUser = UserModel.fromMap(value.data()!);
          emaill = loggedInUser.email;
          rooll = loggedInUser.wrool;
          id = loggedInUser.uid;
          gender = loggedInUser.gender;
          isLoading = false; // Data fetched successfully
        });
      } else {
        print('No user data found');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Widget routing() {
    if (rooll == 'Student') {
      return DashboardScreenStudent(id: id!, url: '', name: '', email: '',);
    } else if (rooll == 'Teacher') {
      return DashboardScreenTeacher(id: id!);
    } else {
      return const Center(child: Text('Role not recognized'));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
            child: CircularProgressIndicator()), // Show loading indicator
      );
    } else {
      return Scaffold(
        body: routing(), // Show routing based on role
      );
    }
  }
}

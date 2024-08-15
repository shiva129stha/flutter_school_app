import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_school_app/screen/login_screen.dart';

class InitState extends StatefulWidget {
  const InitState({super.key});

  @override
  State<InitState> createState() => _InitStateState();
}

class _InitStateState extends State<InitState> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
       color: const Color(0xff42a5f5),
        child: const Center(
          child: Text(
            "       Welcome to \nSNMV School App",
            style: TextStyle(
                fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white,letterSpacing: 2),
          ),
        ),
      ),
    );
  }
}

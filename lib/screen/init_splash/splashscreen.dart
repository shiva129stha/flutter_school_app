// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_school_app/screen/first_main/home.dart';
import 'package:flutter_school_app/screen/first_main/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, SharedPreferences? prefs});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      // Get SharedPreferences instance
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      
      // Retrieve login status
      final bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;

      // Simulate a delay for splash screen effect
      await Future.delayed(const Duration(seconds: 1));

      // Navigate based on login status
      if (isLoggedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePageController()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPageScreen()),
        );
      }
    } catch (e) {
      print('Error checking login status: $e');
      // Navigate to login page in case of error
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPageScreen()),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Container(), // Empty container to avoid layout issues
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_school_app/home.dart';
import 'package:flutter_school_app/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  final SharedPreferences? prefs;

  const SplashScreen({super.key, this.prefs});

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
      if (widget.prefs == null) {
        throw Exception('SharedPreferences instance is null');
      }

      final bool isLoggedIn = widget.prefs?.getBool("isLoggedIn") ?? false;

      // Simulate a delay for splash screen effect
      await Future.delayed(const Duration(milliseconds: 300));

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

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart'; // Import your HomePage widget
import 'forgot.dart'; // Import your Forgot Password widget
import 'package:google_fonts/google_fonts.dart';

import 'verification_screen.dart'; // Import Google Fonts package

class LoginPageScreen extends StatefulWidget {
  const LoginPageScreen({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPageScreen> {
  bool _isObscure3 = true;
  bool isLoading = false; // Added to manage loading state
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 100),
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    "Welcome Back!",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    "Please login to continue",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        // Email TextField
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.orange[50],
                            hintText: 'Email',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
                            }
                            if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (!value.endsWith('@gmail.com')) {
                              emailController.text = '$value@gmail.com';
                              emailController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                    offset: emailController.text.length - 10),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        // Password TextField
                        TextFormField(
                          controller: passwordController,
                          obscureText: _isObscure3,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(_isObscure3
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isObscure3 = !_isObscure3;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: Colors.orange[50],
                            hintText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 40),
                        // Login Button
                        ElevatedButton(
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              bool success = await signIn(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
                              setState(() {
                                isLoading = false;
                              });
                              if (success) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomePageController(),
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[800],
                            padding:
                                const EdgeInsets.symmetric(vertical: 14.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            textStyle: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          child: const Center(child: Text("Login")),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Forgotpass(),
                                  ),
                                );
                              },
                              child: Text(
                                "Forgot Password?",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Colors.orange[800],
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const Text(
                              " | ",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const VerificationScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "Sign Up",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Colors.orange[800],
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Full-screen Circular Progress Indicator
          if (isLoading)
            Container(
              color: Colors.black54, // Semi-transparent background
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Future<bool> signIn(String email, String password) async {
    try {
      // ignore: unused_local_variable
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isLoggedIn", true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePageController(),
        ),
      );

      return true; // Return true if login was successful
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else {
        errorMessage = 'An error occurred. Please try again.';
      }

      // Show the error message using a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );

      return false; // Return false if login failed
    }
  }
}

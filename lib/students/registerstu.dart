import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_school_app/login.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  _TeacherDashboardState createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<StudentDashboard> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController confirmpassController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool _isObscure = true;
  bool _isObscure2 = true;
  final List<String> genderOptions = ['Male', 'Female', 'Other'];
  String _currentGenderSelected = "Male";
  String role = "Student";
  final List<String> roleOptions = ['Student'];
  String _currentRoleSelected = "Student";

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmpassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 100),
              Center(
                child: Text(
                  "Register Now",
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
                  "Please sign up to continue",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Name TextField
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.orange[50],
                        hintText: 'Enter Full Name',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
                          return "Please enter a valid name";
                        }
                        if (value.trim().split(' ').length < 2) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),
                    // Email TextField
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.orange[50],
                        hintText: 'Enter Valid Google Email',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter an email';
                        }
                        if (!RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$')
                            .hasMatch(value)) {
                          return 'Please enter a valid Google email address';
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
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
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
                        if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          return 'Password must contain at least one uppercase letter';
                        }
                        if (!RegExp(r'[0-9]').hasMatch(value)) {
                          return 'Password must contain at least one number';
                        }
                        if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                            .hasMatch(value)) {
                          return 'Password must contain at least one special character';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),
                    // Confirm Password TextField
                    TextFormField(
                      controller: confirmpassController,
                      obscureText: _isObscure2,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(_isObscure2
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscure2 = !_isObscure2;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.orange[50],
                        hintText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Gender and Role Dropdowns
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.orange[50],
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            value: _currentGenderSelected,
                            items: genderOptions.map((String gender) {
                              return DropdownMenuItem<String>(
                                value: gender,
                                child: Text(gender),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _currentGenderSelected = newValue!;
                              });
                            },
                            icon: const Icon(Icons.arrow_drop_down),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.orange[50],
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            value: _currentRoleSelected,
                            items: roleOptions.map((String role) {
                              return DropdownMenuItem<String>(
                                value: role,
                                child: Text(role),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _currentRoleSelected = newValue!;
                                role = newValue;
                              });
                            },
                            icon: const Icon(Icons.arrow_drop_down),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    // Register Button
                    isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                signUp(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                  role,
                                );
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
                            child: const Center(child: Text("Register")),
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPageScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Already have an account? Login",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.orange[800],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password, String role) async {
    setState(() {
      isLoading = true;
    });
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Post details to Firestore
      postDetailsToFirestore(email, role, userCredential.user);

      // Navigate to Login Page after successful sign up
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPageScreen()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      String errorMessage;
      if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is invalid.';
      } else {
        errorMessage = 'An undefined Error happened.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> postDetailsToFirestore(
      String email, String role, User? user) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    UserModel userModel = UserModel(
      uid: user!.uid,
      email: email,
      name: nameController.text.trim(),
      wrool: role,
      gender: _currentGenderSelected,
      role: '',
    );

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
  }
}

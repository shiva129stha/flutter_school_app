import 'package:flutter/material.dart';
import 'package:flutter_school_app/students/registerstu.dart';
import 'package:flutter_school_app/teacher/registertec.dart';


class StudentLoginPage extends StatefulWidget {
  const StudentLoginPage({super.key});

  @override
  _StudentLoginPageState createState() => _StudentLoginPageState();
}

class _StudentLoginPageState extends State<StudentLoginPage> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

  void _login() {
    if (_passwordController.text == "student123") { // Replace with your student password
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StudentDashboard()),
      );
    } else {
      // Handle wrong password
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Incorrect Password'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Student Login', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.school, size: 80, color: Colors.orange[800]),
            const SizedBox(height: 20),
            Text(
              'Student Login',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange[800],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: _isObscure,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: Icon(Icons.lock, color: Colors.orange[800]),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                    color: Colors.orange[800],
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
                filled: true,
                fillColor: Colors.orange[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                hintStyle: TextStyle(color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[800],
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TeacherLoginPage extends StatefulWidget {
  const TeacherLoginPage({super.key});

  @override
  _TeacherLoginPageState createState() => _TeacherLoginPageState();
}

class _TeacherLoginPageState extends State<TeacherLoginPage> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

  void _login() {
    if (_passwordController.text == "teacher123") { // Replace with your teacher password
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TeacherDashboard()),
      );
    } else {
      // Handle wrong password
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Incorrect Password'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Teacher Login', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.school, size: 80, color: Colors.orange[800]),
            const SizedBox(height: 20),
            Text(
              'Teacher Login',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange[800],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: _isObscure,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: Icon(Icons.lock, color: Colors.orange[800]),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                    color: Colors.orange[800],
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
                filled: true,
                fillColor: Colors.orange[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                hintStyle: TextStyle(color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[800],
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

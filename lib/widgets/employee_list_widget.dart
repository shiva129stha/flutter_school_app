import 'package:flutter/material.dart';
import 'package:flutter_school_app/screen/techerphone/teacher_details_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class EmployeeListScreen extends StatelessWidget {
  final List<Map<String, String>> employees = [
    // Add sample employee data
    {'name': 'John Doe', 'phoneNo': '1234567890', 'email': 'john@example.com', 'designation': 'Teacher'},
    // Add more employee data as needed
  ];

   EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Scrollbar(
        thumbVisibility: true, // Show the thumb even if not scrolling
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: employees.length,
          itemBuilder: (context, index) {
            final employee = employees[index];
            return EmployeeListWidget(
              name: employee['name'],
              phoneNo: employee['phoneNo'],
              email: employee['email'],
              designation: employee['designation'],
            );
          },
        ),
      ),
    );
  }
}

class EmployeeListWidget extends StatelessWidget {
  final String? name;
  final String? phoneNo;
  final String? email;
  final String? designation;

  const EmployeeListWidget({
    super.key,
    this.name,
    this.phoneNo,
    this.email,
    this.designation,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TeacherDetailsScreen(
              name: name,
              phoneNo: phoneNo,
              email: email,
              designation: designation,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.deepPurple.shade100,
              child: Text(
                name != null && name!.isNotEmpty ? name![0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 69, 39, 160),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name ?? 'Name not available',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    designation ?? 'Designation not available',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: phoneNo != null && phoneNo!.isNotEmpty
                  ? () async {
                      final uri = Uri.parse("tel:$phoneNo");
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Cannot make a call to $phoneNo'),
                            backgroundColor: Colors.red.shade600,
                          ),
                        );
                      }
                    }
                  : null,
              icon: const Icon(Icons.phone, color: Colors.teal),
              tooltip: 'Call',
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_school_app/screen/techerphone/teacher_details_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class EmployeeListWidget extends StatelessWidget {
  final String? name;
  final String? phoneNo;
  final String? email;
  final String? designation;

  const EmployeeListWidget(
      {super.key, this.name, this.phoneNo, this.email, this.designation});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (cxt) => TeacherDetailsScreen(
                      name: name,
                      phoneNo: phoneNo,
                      email: email,
                      designation: designation,
                    )));
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.shade300,
              child: Text(
                name!.isNotEmpty ? name![0].toUpperCase() : '?',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name ?? 'Name not available',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    designation ?? 'Designation not available',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
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
                        // Handle error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Cannot make a call to $phoneNo'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  : null,
              icon: const Icon(Icons.phone, color: Colors.green),
              tooltip: 'Call',
            ),
          ],
        ),
      ),
    );
  }
}

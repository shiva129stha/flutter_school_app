// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_school_app/screen/teacher_details_screen.dart';
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
        height: 80,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade300),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.green,
              child: Text(
                name!.substring(0, 1).toUpperCase(),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name!,
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  Text(
                    designation!,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed: () async {
                  await launch("tel:$phoneNo");
                },
                icon: const Icon(
                  Icons.phone,
                  color: Colors.green,
                )),
          ],
        ),
      ),
    );
  }
}

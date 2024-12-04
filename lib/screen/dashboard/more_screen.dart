import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          'Want To Know More...',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.only(top: 300),
          child: Column(
            children: [
              Text(
                "To Know about our school more ..",
                style: TextStyle(color: Colors.blue.shade400, fontSize: 19),
              ),
              const SizedBox(
                height: 10,
              ),
              Icon(
                Icons.arrow_downward_sharp,
                color: Colors.blue.shade600,
              ),
              TextButton(
                onPressed: () {
                  // ignore: deprecated_member_use
                  launch("https://pranish-maharjan.github.io/Saraswati-Niketan-Secondary-School/");
                },
                child: Text("Click Me",
                    style: TextStyle(
                        color: Colors.blue.shade400,
                        fontSize: 19,
                        decoration: TextDecoration.underline)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_school_app/firebase_options.dart';
import 'package:flutter_school_app/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Handle background message
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
       options: DefaultFirebaseOptions.currentPlatform,
    ); 
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // Initialize Firebase
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  SharedPreferences? prefs;
  try {
    prefs = await SharedPreferences.getInstance();
  } catch (e) {
    print('Error initializing SharedPreferences: $e');
  }

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences? prefs;

  const MyApp({super.key, this.prefs});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'School App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(prefs: prefs),
    );
  }
}

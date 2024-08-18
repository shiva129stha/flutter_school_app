// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter_school_app/screen/dashboard_screen_teacher.dart';
// import 'package:flutter_school_app/services/auth_repository.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   @override
//   Widget build(BuildContext context) {
   
//     return Scaffold(
//       body: SizedBox(
//         height: double.infinity,
//         width: double.infinity,
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children:<Widget> [
              
//               // const SizedBox(
//               //   height: 150.0,
//               //   width: 100.0,
//               // ),
//               const Image(image: AssetImage('assets/images/google1.jpg'),height: 50,width: 50,),
//               const Text(
//                 "Welcome to App",
//                 style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold),
//               ),
              
//               const SizedBox(
//                 height: 20,
//               ),
//               const Text(
//                 "Create an account to save all schedules and access them from anywhere",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 18,
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(
//                 height: 100,
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   try {
//                     var googleUser = await AuthRepository().signInWithGoogle();
//                     if (googleUser != null) {
//                       var googleSignInAuthentication =
//                           await googleUser.authentication;

//                       var googleToken = googleSignInAuthentication.accessToken;
//                       if (googleToken != null) {
//                         Navigator.of(context).push(MaterialPageRoute(
//                             builder: (_) =>  DashboardScreen()));
//                       }
//                     }
//                   } catch (e) {
//                     // ignore: avoid_print
//                     print("Error occur $e");
//                   }
//                 },
//                 style: ButtonStyle(
//                   padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
//                       EdgeInsets.zero),
//                   backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
//                   shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//                       RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10))),
//                 ),
//                 child: const Padding(
//                   padding: EdgeInsets.all(8),
//                   child: Row(
//                     children: [
//                       SizedBox(width: 24),
//              Image(image: AssetImage('assets/images/google1.jpg'),height: 50,width: 50,),
//               Padding(padding: EdgeInsets.only(left:10),
//               ),

//                       Center(
//                         child: Text(
//                           "Login with Google",
//                           style: TextStyle(
//                             fontSize: 18,
//                             color: Colors.black,
                            
//                           ),
//                         ),
//                       ),

//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

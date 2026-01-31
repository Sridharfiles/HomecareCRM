import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:homecarecrm/screens/login.dart';
import 'package:homecarecrm/screens/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HomeCare CRM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Login(),
      routes: {
        '/login': (context) => Login(),
        '/signup': (context) => const Signup(),
      },
    );
  }
}
import 'package:bookify/screens/auth_screens/Auth_Home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Bookify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xffF7511D),
      ),
      home: LoginAndSignUp(),
    );
  }
}

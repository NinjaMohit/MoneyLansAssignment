import 'package:flutter/material.dart';
import 'screen/user_signin_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Color.fromRGBO(181, 171, 244, 1),
      home: SignInScreen(),
    );
  }
}

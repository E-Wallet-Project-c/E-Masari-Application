import 'package:flutter/material.dart';
import 'auth/login_screen.dart';

void main() {
  runApp(const MasariApp());
}

class MasariApp extends StatelessWidget {
  const MasariApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Masari Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0094D9),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Color(0xFFE0E0E0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Color(0xFF0094D9), width: 1.3),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

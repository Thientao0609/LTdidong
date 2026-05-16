import 'package:flutter/material.dart';
import 'screens/sign_in.dart';

void main() {
  runApp(const Fellow4UApp());
}

class Fellow4UApp extends StatelessWidget {
  const Fellow4UApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fellow4U UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Helvetica', // Hoặc 'Roboto'
        scaffoldBackgroundColor: Colors.white,
      ),
      // App sẽ bắt đầu từ trang Đăng Nhập
      home: const SignInScreen(),
    );
  }
}

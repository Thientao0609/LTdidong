import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Thêm dòng này
import 'firebase_options.dart'; // Thêm dòng này (file tạo ra sau khi chạy flutterfire configure)
import 'welcome.dart';

void main() async {
  // Đảm bảo các dịch vụ của Flutter đã sẵn sàng
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khởi tạo Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travel App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00D1B2)),
      ),
      home: const WelcomeScreen(),
    );
  }
}
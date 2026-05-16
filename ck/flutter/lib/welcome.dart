import 'package:flutter/material.dart';
import 'signin.dart'; // 1. Sửa lại import trang Sign Up mới

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              const SizedBox(height: 50), 
              
              // Hình ảnh minh họa
              Expanded(
                flex: 5,
                child: Center(
                  child: Image.asset(
                    'assets/welcome.jpg', 
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              
              const SizedBox(height: 30),

              // Tiêu đề
              const Text(
                'Create a trip and get offers',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26, 
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
              ),
              
              const SizedBox(height: 15),

              // Mô tả
              Text(
                'Fellow-4U helps you save time and get offers from hundred local guides that suit your trip.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16, 
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),

              const Spacer(), // Đẩy nút bấm xuống cuối trang

              // Nút GET STARTED
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // 2. Chuyển hướng sang SignUpScreen 
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignInScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00D1B2),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'GET STARTED', 
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
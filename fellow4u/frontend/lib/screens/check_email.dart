import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/widgets.dart';

class CheckEmailScreen extends StatelessWidget {
  const CheckEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CurvedHeader(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Check Email',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Please check your email for the instructions on\nhow to reset your password.',
                  style: TextStyle(color: hintColor, fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 60),

                // Icon mô phỏng thư
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.mark_email_unread_outlined,
                      size: 90,
                      color: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 80),

                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text.rich(
                      TextSpan(
                        text: 'Back to ',
                        style: TextStyle(color: hintColor, fontSize: 13),
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

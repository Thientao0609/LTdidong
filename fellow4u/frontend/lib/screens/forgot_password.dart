import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/widgets.dart';
import 'check_email.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

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
                  'Forgot Password',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Input your email, we will send you an\ninstruction to reset your password.',
                  style: TextStyle(color: hintColor, fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 40),

                const CustomTextField(
                  labelText: 'Email',
                  hintText: 'yoojin@gmail.com',
                ),
                const SizedBox(height: 10),

                PrimaryButton(
                  text: 'SEND',
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CheckEmailScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

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

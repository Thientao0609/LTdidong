import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'checkmail.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final TextEditingController emailController = TextEditingController();

  Future resetPassword() async {

    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your email")),
      );
      return;
    }

    try {

      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CheckEmailPage(),
        ),
      );

    } on FirebaseAuthException catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Something went wrong"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Column(
          children: [

            /// HEADER
            Stack(
              children: [
                ClipPath(
                  clipper: HeaderClipper(),
                  child: Container(
                    height: 250,
                    width: double.infinity,
                    color: const Color(0xFF00D1B2),

                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30, top: 20),
                        child: Align(
                          alignment: Alignment.topLeft,

                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),

                            child: const Icon(
                              Icons.bubble_chart,
                              color: Color(0xFF00D1B2),
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            /// FORM
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 20),

                  const Text(
                    'Forgot Password',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Input your email, we will send you an instruction to reset your password.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// EMAIL LABEL
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  /// EMAIL INPUT
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'yoojin@gmail.com',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF00D1B2)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  /// SEND BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(
                      onPressed: resetPassword,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00D1B2),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                      ),

                      child: const Text(
                        'SEND',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// BACK TO SIGN IN
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        const Text('Back to '),

                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },

                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              color: Color(0xFF00D1B2),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// HEADER CURVE
class HeaderClipper extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {

    Path path = Path();

    path.lineTo(0, size.height - 80);

    path.quadraticBezierTo(
      size.width / 2,
      size.height + 20,
      size.width,
      size.height - 80,
    );

    path.lineTo(size.width, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
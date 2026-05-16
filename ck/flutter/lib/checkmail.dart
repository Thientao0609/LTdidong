import 'package:flutter/material.dart';

class CheckEmailPage extends StatelessWidget {
  const CheckEmailPage({super.key});

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

            /// CONTENT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 20),

                  const Text(
                    "Check Email",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Please check your email for the instructions on how to reset your password.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 60),

                  /// EMAIL ICON
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),

                      child: const Icon(
                        Icons.mail_outline,
                        size: 80,
                        color: Color(0xFF00D1B2),
                      ),
                    ),
                  ),

                  const SizedBox(height: 80),

                  /// BACK TO SIGN IN
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        const Text("Back to "),

                        GestureDetector(
                          onTap: () {
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                          },

                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              color: Color(0xFF00D1B2),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            )
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
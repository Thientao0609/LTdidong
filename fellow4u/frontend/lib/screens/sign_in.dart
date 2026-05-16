import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/widgets.dart';
import '../core/api_service.dart';
import 'sign_up.dart';
import 'forgot_password.dart';
import 'main_screen.dart'; // Đã thay home.dart thành main_screen.dart

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLogin() async {
    setState(() => _isLoading = true);
    final result = await ApiService.login(
      _emailController.text,
      _passwordController.text,
    );
    setState(() => _isLoading = false);

    if (result['success'] == true) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đăng nhập thành công!'),
          backgroundColor: Colors.green,
        ),
      );
      // Chuyển vào MainScreen sau một chút delay để user thấy thông báo
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      });
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Login failed'),
          backgroundColor: Colors.redAccent,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CurvedHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Welcome back, Yoo Jin',
                    style: TextStyle(fontSize: 18, color: primaryColor),
                  ),
                  const SizedBox(height: 40),

                  CustomTextField(
                    labelText: 'Email',
                    hintText: 'yoojin@gmail.com',
                    controller: _emailController,
                  ),
                  CustomTextField(
                    labelText: 'Password',
                    hintText: '••••••',
                    isPassword: true,
                    controller: _passwordController,
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      ),
                      child: const Text(
                        'Forgot Password',
                        style: TextStyle(color: hintColor, fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  _isLoading 
                    ? const Center(child: CircularProgressIndicator(color: primaryColor))
                    : PrimaryButton(text: 'SIGN IN', onPressed: _handleLogin),
                  const SizedBox(height: 30),

                  const Center(
                    child: Text(
                      'or sign in with',
                      style: TextStyle(color: hintColor, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Social Login Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialIcon(const Color(0xFF3B5998), 'f', isIcon: true),
                      const SizedBox(width: 15),
                      _socialIcon(
                        const Color(0xFFFFE812),
                        'TALK',
                        textColor: Colors.black,
                      ),
                      const SizedBox(width: 15),
                      _socialIcon(const Color(0xFF00C300), 'LINE'),
                    ],
                  ),
                  const SizedBox(height: 40),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: hintColor, fontSize: 13),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialIcon(
    Color bgColor,
    String text, {
    bool isIcon = false,
    Color textColor = Colors.white,
  }) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: isIcon ? 28 : 11,
            fontWeight: FontWeight.bold,
            fontFamily: isIcon ? 'serif' : 'sans-serif',
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  static const Color primaryColor = Color(0xFF12CDB0);

  String? userType = 'Traveler';

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _handleSignUp() async {
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty ||
        _countryController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _confirmPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin")),
      );
      return;
    }

    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mật khẩu xác nhận không khớp"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final String fullName = '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'.trim();
      await userCredential.user!.updateDisplayName(fullName);

      final idToken = await userCredential.user!.getIdToken();

      if (idToken == null) {
        throw Exception("Không lấy được Firebase token");
      }

      await AuthService.sendFirebaseToken(idToken);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Đăng ký thành công"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      String message = e.message ?? "Đã có lỗi xảy ra";
      if (e.code == 'weak-password') {
        message = "Mật khẩu quá yếu";
      } else if (e.code == 'email-already-in-use') {
        message = "Email này đã được sử dụng";
      } else if (e.code == 'invalid-email') {
        message = "Email không hợp lệ";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst("Exception: ", "")),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _countryController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 22),
                    const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _buildUserTypeRow(),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _buildUnderlineField(
                            label: "First Name",
                            hint: "Yoo",
                            controller: _firstNameController,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildUnderlineField(
                            label: "Last Name",
                            hint: "Jin",
                            controller: _lastNameController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    _buildUnderlineField(
                      label: "Country",
                      hint: "Country",
                      controller: _countryController,
                    ),
                    const SizedBox(height: 4),
                    _buildUnderlineField(
                      label: "Email",
                      hint: "Type email",
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 4),
                    _buildUnderlineField(
                      label: "Password",
                      hint: "Type password",
                      controller: _passwordController,
                      isPassword: true,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Password has more than 6 letters",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildUnderlineField(
                      label: "Confirm Password",
                      hint: "••••••",
                      controller: _confirmPasswordController,
                      isConfirmPassword: true,
                    ),
                    const SizedBox(height: 18),
                    RichText(
                      text: const TextSpan(
                        text: "By Signing Up, you agree to our ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                        children: [
                          TextSpan(
                            text: "Terms & Conditions",
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleSignUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shadowColor: primaryColor.withOpacity(.35),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.4,
                                ),
                              )
                            : const Text(
                                "SIGN UP",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: .4,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: RichText(
                          text: const TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                            children: [
                              TextSpan(
                                text: "Sign In",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 190,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            color: primaryColor,
          ),
          Positioned(
            top: 18,
            left: 22,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.travel_explore,
                color: primaryColor,
                size: 28,
              ),
            ),
          ),
          Positioned(
            top: 22,
            right: 20,
            child: Icon(
              Icons.flight_takeoff,
              color: Colors.white.withOpacity(.12),
              size: 56,
            ),
          ),
          Positioned(
            top: 58,
            right: 92,
            child: Icon(
              Icons.cloud,
              color: Colors.white.withOpacity(.10),
              size: 28,
            ),
          ),
          Positioned(
            top: 70,
            left: 90,
            child: Icon(
              Icons.place_outlined,
              color: Colors.white.withOpacity(.10),
              size: 28,
            ),
          ),
          Positioned(
            bottom: 0,
            left: -30,
            right: -30,
            child: Container(
              height: 85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.elliptical(320, 60),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserTypeRow() {
    return Row(
      children: [
        _buildRadioOption("Traveler"),
        const SizedBox(width: 24),
        _buildRadioOption("Guide"),
      ],
    );
  }

  Widget _buildRadioOption(String value) {
    final selected = userType == value;

    return InkWell(
      onTap: () {
        setState(() {
          userType = value;
        });
      },
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? primaryColor : Colors.grey,
                width: 1.6,
              ),
            ),
            child: selected
                ? Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnderlineField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
    bool isConfirmPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    bool obscure = false;
    if (isPassword) obscure = _obscurePassword;
    if (isConfirmPassword) obscure = _obscureConfirmPassword;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        TextField(
          controller: controller,
          obscureText: isPassword || isConfirmPassword ? obscure : false,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            border: InputBorder.none,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFD6D6D6)),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 1.5),
            ),
            suffixIcon: (isPassword || isConfirmPassword)
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        if (isPassword) {
                          _obscurePassword = !_obscurePassword;
                        }
                        if (isConfirmPassword) {
                          _obscureConfirmPassword =
                              !_obscureConfirmPassword;
                        }
                      });
                    },
                    icon: Icon(
                      obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: Colors.grey,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/widgets.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Change Password',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'SAVE',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [
            CustomTextField(
              labelText: 'Current Password',
              hintText: '••••••',
              isPassword: true,
            ),
            CustomTextField(
              labelText: 'New Password',
              hintText: '••••••',
              isPassword: true,
            ),
            CustomTextField(
              labelText: 'Retype New Password',
              hintText: '••••••',
              isPassword: true,
            ),
          ],
        ),
      ),
    );
  }
}

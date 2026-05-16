import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'edit_profile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifEnabled = true;

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
          'Settings',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Banner User
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=100',
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Yoo Jin',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Traveler',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'EDIT PROFILE',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          _buildMenuItem(
            Icons.notifications_none,
            'Notifications',
            trailing: Switch(
              value: _notifEnabled,
              activeColor: primaryColor,
              onChanged: (v) => setState(() => _notifEnabled = v),
            ),
          ),
          _buildMenuItem(Icons.language, 'Languages'),
          _buildMenuItem(Icons.payment, 'Payment'),
          _buildMenuItem(Icons.privacy_tip_outlined, 'Privacy & Policies'),
          _buildMenuItem(Icons.feedback_outlined, 'Feedback'),
          _buildMenuItem(Icons.data_usage, 'Usage'),
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: const Text('Sign out', style: TextStyle(color: hintColor)),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {Widget? trailing}) {
    return ListTile(
      leading: Icon(icon, color: hintColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing:
          trailing ??
          const Icon(Icons.arrow_forward_ios, size: 14, color: hintColor),
    );
  }
}

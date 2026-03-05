import 'package:flutter/material.dart';

class InvitePage extends StatelessWidget {
  const InvitePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B00D1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Invite Friends", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration Image
            Image.network(
              "https://cdni.iconscout.com/illustration/premium/thumb/friends-referral-illustration-download-in-svg-png-gif-file-formats--refer-a-friend-customer-loyalty-marketing-referring-business-pack-illustrations-5047466.png",
              height: 250,
            ),
            const SizedBox(height: 30),
            const Text(
              "Invite your Friends",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Learn together with friends",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 50),

            // Social Buttons
            _buildSocialButton("Whatsapp", Icons.chat_bubble, const Color(0xFF5F2EFF), Colors.white),
            const SizedBox(height: 15),
            _buildSocialButton("Text Message", Icons.sms, Colors.white, Colors.blue, isOutlined: true),
            const SizedBox(height: 15),
            _buildSocialButton("More Options", Icons.grid_view_rounded, Colors.white, Colors.blue, isOutlined: true),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(String text, IconData icon, Color bgColor, Color textColor, {bool isOutlined = false}) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, color: isOutlined ? Colors.blue : Colors.white),
        label: Text(text, style: TextStyle(color: isOutlined ? Colors.blue : Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          elevation: 0,
          side: isOutlined ? const BorderSide(color: Color(0xFFE0E0E0)) : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }
}
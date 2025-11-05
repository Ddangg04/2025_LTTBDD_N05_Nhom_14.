import 'package:flutter/material.dart';
import 'booking_screen.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang quản trị sân bóng'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: const Text('Danh sách đặt sân'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const BookingScreen())),
          ),
        ],
      ),
    );
  }
}

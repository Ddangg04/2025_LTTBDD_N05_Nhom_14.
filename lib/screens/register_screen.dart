import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'booking_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  String message = "";

  Future<void> register() async {
    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      await cred.user!.updateDisplayName(nameController.text.trim());
      setState(() => message = "Tạo tài khoản thành công!");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => const HomeScreen(
                  fieldId: '',
                  fieldName: null,
                  number: null,
                )),
      );
    } catch (e) {
      setState(() => message = "Lỗi: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Đăng ký tài khoản",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Tên hiển thị")),
              TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email")),
              TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Mật khẩu")),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: register,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white),
                child: const Text("Đăng ký"),
              ),
              const SizedBox(height: 10),
              Text(message, style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}

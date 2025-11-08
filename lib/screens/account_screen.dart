import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'MyBookings_Screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  Future<void> _changePasswordDialog() async {
    final TextEditingController newPasswordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đổi mật khẩu'),
        content: TextField(
          controller: newPasswordController,
          decoration: const InputDecoration(
            labelText: 'Nhập mật khẩu mới',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newPassword = newPasswordController.text.trim();
              if (newPassword.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Mật khẩu phải có ít nhất 6 ký tự')),
                );
                return;
              }

              try {
                await _user!.updatePassword(newPassword);
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đổi mật khẩu thành công')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lỗi: $e')),
                );
              }
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    await _auth.signOut();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng xuất thành công')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tài khoản'),
        backgroundColor: const Color.fromARGB(255, 208, 66, 244),
        foregroundColor: Colors.white,
      ),
      body: user == null
          ? const Center(child: Text('Không có người dùng nào đang đăng nhập.'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.displayName ?? 'Người dùng Phenikaa',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user.email ?? 'Không có email',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  ListTile(
                    leading: const Icon(Icons.calendar_today_outlined),
                    title: const Text('Lịch sử đặt sân'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyBookingsScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.lock_outline),
                    title: const Text('Đổi mật khẩu'),
                    onTap: _changePasswordDialog,
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Đăng xuất'),
                    onTap: _logout,
                  ),
                ],
              ),
            ),
    );
  }
}

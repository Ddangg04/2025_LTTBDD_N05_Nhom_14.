import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liên hệ nhóm thực hiện'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xfff5f5f5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            const Text(
              "Thông tin thành viên nhóm",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),

            _buildMemberCard(
              name: "Vũ Hồng Phúc",
              studentId: "MSSV: 23010855",
              role: "",
              avatarUrl:
                  "https://cdn-icons-png.flaticon.com/512/1946/1946429.png",
            ),

            const SizedBox(height: 16),

            _buildMemberCard(
              name: "Nguyễn Danh Bảo Đăng",
              studentId: "MSSV: 22010507",
              role: "",
              avatarUrl:
                  "https://cdn-icons-png.flaticon.com/512/1946/1946429.png",
            ),

            const SizedBox(height: 30),
            const Divider(),


            const Text(
              "Liên hệ với nhóm",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 8),
            const Text(
              "Email: nhom14@phenikaa.edu.vn\nSĐT: 0123 456 789",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // 🌐 Icon mạng xã hội
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.facebook, color: Colors.blue),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.email, color: Colors.redAccent),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.phone, color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }


  Widget _buildMemberCard({
    required String name,
    required String studentId,
    required String role,
    required String avatarUrl,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.grey.shade300,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                avatarUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style:
                          const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(studentId),
                  const SizedBox(height: 4),
                  Text(role,
                      style: const TextStyle(
                          color: Colors.grey, fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

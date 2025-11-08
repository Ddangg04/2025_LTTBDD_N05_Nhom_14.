import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Bạn chưa đăng nhập')),
      );
    }

    final userId = user.uid;
    final bookingRef = FirebaseDatabase.instance.ref().child('bookings');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 95, 89, 211),
        foregroundColor: Colors.white,
        title: const Text('Lịch đặt của tôi'),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: FirebaseDatabase.instance.ref().child('bookings').onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text('Chưa có sân nào được đặt.'));
          }

          final data = Map<String, dynamic>.from(
            snapshot.data!.snapshot.value as Map<dynamic, dynamic>,
          );

          final bookings = data.entries.map((e) {
            final booking = Map<String, dynamic>.from(e.value);
            return {
              'fieldName': booking['fieldName'] ?? 'Không rõ sân',
              'date': booking['date'] ?? '',
              'timeSlot': booking['timeSlot'] ?? '',
              'status': booking['status'] ?? 'chờ duyệt',
              'services': booking['services'] ?? [],
            };
          }).toList();

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final b = bookings[index];
              final services =
                  (b['services'] as List?)?.join(', ') ?? 'Không có dịch vụ';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.sports_soccer,
                      color: Color.fromARGB(255, 42, 109, 167)),
                  title: Text(b['fieldName'],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('📅 Ngày: ${b['date']}'),
                      Text('🕓 Khung giờ: ${b['timeSlot']}'),
                      Text('💬 Trạng thái: ${b['status']}'),
                      Text('🎒 Dịch vụ: $services'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch đặt của tôi'),
      ),
      body: userId == null
          ? const Center(child: Text('Bạn chưa đăng nhập'))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('bookings')
                  .where('userId', isEqualTo: userId)
                  .orderBy('startTime', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Bạn chưa có lịch đặt nào.'));
                }

                final bookings = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final data = bookings[index].data() as Map<String, dynamic>;

                    final fieldName = data['fieldName'] ?? 'Không rõ sân';
                    final startTime = (data['startTime'] as Timestamp).toDate();
                    final endTime = (data['endTime'] as Timestamp).toDate();
                    final price = data['price'] ?? 0;
                    final status = data['status'] ?? 'pending';

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      elevation: 3,
                      child: ListTile(
                        title: Text(fieldName,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 6),
                            Text('Thời gian: ${startTime.toString()} - ${endTime.toString()}'),
                            Text('Giá: $price VND'),
                            Text('Trạng thái: $status'),
                          ],
                        ),
                        trailing: Icon(
                          Icons.sports_soccer,
                          color: Colors.green.shade700,
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

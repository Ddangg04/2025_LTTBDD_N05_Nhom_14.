import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen(
      {super.key,
      required String fieldId,
      required fieldName,
      required number});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách đặt sân')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('bookings').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final data = snapshot.data!.docs;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final booking = data[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading:
                      const Icon(Icons.calendar_month, color: Colors.green),
                  title: Text('Sân: ${booking['fieldName']}'),
                  subtitle: Text(
                      'Ngày: ${booking['date']} - Giờ: ${booking['timeSlot']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => booking.reference.delete(),
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

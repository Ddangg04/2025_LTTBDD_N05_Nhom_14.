import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'booking_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen(
      {super.key,
      required number,
      required fieldName,
      required String fieldId});

  @override
  Widget build(BuildContext context) {
    final fields = FirebaseFirestore.instance.collection('fields');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách sân bóng'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fields.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(
                child: Text("Chưa có sân bóng nào trong hệ thống."));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final field = docs[index];
              final status = field['status'] ?? 'trong';

              return Card(
                margin: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    field['imageUrl'] != null
                        ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(15)),
                            child: Image.network(
                              field['imageUrl'],
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            height: 180,
                            color: Colors.grey[300],
                            child: const Center(
                                child: Icon(Icons.image_not_supported)),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            field['name'] ?? 'Sân không tên',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text('Số sân: ${field['number']}'),
                          const SizedBox(height: 4),
                          Text(
                            'Trạng thái: ${status == 'trong' ? '🟢 Trống' : '🔴 Đã đặt'}',
                            style: TextStyle(
                                color: status == 'trong'
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: status == 'trong'
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BookingScreen(
                                          fieldId: field.id,
                                          fieldName: field['name'],
                                          number: field['number'],
                                        ),
                                      ),
                                    );
                                  }
                                : null,
                            icon: const Icon(Icons.calendar_month),
                            label: const Text('Đặt sân'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 45),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../services/field_service.dart';
import 'booking_screen.dart';
import 'contact_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(
      {super.key,
      required String fieldId,
      required fieldName,
      required number});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FieldService _fieldService = FieldService();

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text('Đặt sân bóng Phenikaa'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'Menu Điều Hướng',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Trang chủ'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.room_service_outlined),
              title: const Text('Dịch vụ'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today_outlined),
              title: const Text('Lịch đặt của tôi'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Tài khoản'),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text('Liên hệ'),
              onTap: () {
                Navigator.pop(context); 
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: _fieldService.getFieldsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text("Đang tải danh sách sân..."));
          }

          final data =
              Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
          final fields = data.entries.map((e) {
            final f = Map<String, dynamic>.from(e.value);
            return {
              'key': e.key,
              'name': f['name'],
              'number': f['number'],
              'imageUrl': f['imageUrl'],
              'status': f['status'],
              'price': f['price'],
              'description': f['description'],
            };
          }).toList();

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: fields.length,
            itemBuilder: (context, index) {
              final field = fields[index];
              final status = field['status'] ?? 'trong';
              final isAvailable = status == 'trong';

              return GestureDetector(
                onTap: isAvailable
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingScreen(
                              fieldId: field['key'],
                              fieldName: field['name'],
                              imageUrl: field['imageUrl'],
                              price: field['price'],
                              number: null,
                            ),
                          ),
                        );
                      }
                    : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 6,
                        offset: const Offset(2, 3),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                          child: field['imageUrl'] != null
                              ? Image.network(
                                  field['imageUrl'],
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported,
                                      size: 50),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              field['name'] ?? 'Sân bóng',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text('Giá: ${field['price'] ?? 0} VNĐ'),
                            Text(
                              status == 'trong'
                                  ? 'Trống'
                                  : status == 'đang đặt'
                                      ? 'Đang đặt'
                                      : 'Bảo trì',
                              style: TextStyle(
                                color: isAvailable
                                    ? Colors.green
                                    : (status == 'đang đặt'
                                        ? Colors.orange
                                        : Colors.red),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BookingScreen(
                    fieldId: 'default_id',
                    fieldName: 'Sân bóng',
                    imageUrl: '',
                    price: 0,
                    number: 0,
                  ),
                ),
              );

              break;
            case 2:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Tính năng thông báo đang phát triển')),
              );
              break;
            case 3:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Trang tài khoản đang phát triển')),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Đặt sân',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: 'Thông báo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }
}

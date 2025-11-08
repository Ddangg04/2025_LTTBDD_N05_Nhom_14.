import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';

class BookingScreen extends StatefulWidget {
  final String fieldId;
  final String fieldName;
  final String imageUrl;
  final int? price;

  const BookingScreen({
    super.key,
    required this.fieldId,
    required this.fieldName,
    required this.imageUrl,
    this.price,
    required number,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime selectedDate = DateTime.now();
  String? selectedTimeSlot;
  List<String> selectedServices = [];

  final List<String> timeSlots = [
    '06:00 - 07:30',
    '07:30 - 09:00',
    '09:00 - 10:30',
    '14:00 - 15:30',
    '15:30 - 17:00',
    '17:00 - 18:30',
    '18:30 - 20:00',
    '20:00 - 21:30',
  ];

  final List<Map<String, dynamic>> serviceList = [
    {'name': 'Nước khoáng', 'price': 10000},
    {'name': 'Áo pit', 'price': 20000},
    {'name': 'Coca', 'price': 15000},
    {'name': 'Chanh muối', 'price': 10000},
    {'name': 'Trà đá', 'price': 5000},
    {'name': 'Sâm dứa', 'price': 15000},
  ];

  bool isLoading = false;
  bool slotAvailable = true;

  Future<void> checkAvailability() async {
    final db = FirebaseDatabase.instance.ref('bookings');
    final snapshot = await db.get();
    if (snapshot.value == null) return;
    final bookings = Map<String, dynamic>.from(snapshot.value as Map);
    final exists = bookings.values.any((b) =>
        b['fieldId'] == widget.fieldId &&
        b['date'] == DateFormat('dd/MM/yyyy').format(selectedDate) &&
        b['timeSlot'] == selectedTimeSlot);
    setState(() => slotAvailable = !exists);
  }

  Future<void> submitBooking() async {
    if (selectedTimeSlot == null) return;
    setState(() => isLoading = true);
    await checkAvailability();
    if (!slotAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Khung giờ này đã có người đặt!')));
      setState(() => isLoading = false);
      return;
    }

    final db = FirebaseDatabase.instance.ref('bookings').push();
    await db.set({
      'fieldId': widget.fieldId,
      'fieldName': widget.fieldName,
      'date': DateFormat('dd/MM/yyyy').format(selectedDate),
      'timeSlot': selectedTimeSlot,
      'services': selectedServices,
      'status': 'chờ duyệt',
      'createdAt': DateTime.now().toIso8601String(),
    });

    setState(() => isLoading = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('✅ Đặt sân thành công')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: Text('Đặt sân: ${widget.fieldName}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child:
                Image.network(widget.imageUrl, height: 180, fit: BoxFit.cover),
          ),
          const SizedBox(height: 12),
          Text('Giá: ${widget.price ?? 0} VNĐ / 1h30p',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Divider(),
          Row(
            children: [
              const Text('Ngày: ',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2026),
                  );
                  if (picked != null) setState(() => selectedDate = picked);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white),
                child: const Text('Chọn ngày'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Khung giờ:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 10,
            children: timeSlots.map((slot) {
              final selected = selectedTimeSlot == slot;
              return ChoiceChip(
                label: Text(slot),
                selected: selected,
                selectedColor: Colors.green,
                onSelected: (_) => setState(() => selectedTimeSlot = slot),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Text(slotAvailable ? 'Sân trống' : 'Đã đặt',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: slotAvailable ? Colors.green : Colors.red)),
          const Divider(),
          const Text('Chọn dịch vụ kèm theo:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          ...serviceList.map((s) {
            return CheckboxListTile(
              title: Text('${s['name']} (${s['price']}đ)'),
              value: selectedServices.contains(s['name']),
              onChanged: (val) {
                setState(() {
                  if (val == true) {
                    selectedServices.add(s['name']);
                  } else {
                    selectedServices.remove(s['name']);
                  }
                });
              },
            );
          }),
          const SizedBox(height: 15),
          ElevatedButton.icon(
            onPressed: isLoading ? null : submitBooking,
            icon: const Icon(Icons.check),
            label: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Xác nhận đặt sân'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }
}

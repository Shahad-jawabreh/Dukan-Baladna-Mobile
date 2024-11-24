import 'package:flutter/material.dart';

class ComplaintDetails extends StatelessWidget {
  final Map<String, dynamic> complaint;

  const ComplaintDetails({required this.complaint, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الشكوى'),
        backgroundColor: Color(0xFF94A96B),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "عنوان الشكوى: ${complaint['subject']}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "تفاصيل الشكوى:\n${complaint['details']}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              "الحالة: ${complaint['status']}",
              style: TextStyle(
                fontSize: 16,
                color: complaint['status'] == 'Pending' ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // إجراء الرد أو التغيير
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("تم الرد على الشكوى.")),
                );
              },
              child: const Text("رد على الشكوى"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                // إجراء الحذف
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("تم حذف الشكوى.")),
                );
              },
              child: const Text("حذف الشكوى"),
            ),
          ],
        ),
      ),
    );
  }
}

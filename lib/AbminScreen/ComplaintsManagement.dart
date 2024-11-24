import 'package:flutter/material.dart';
import 'ComplaintDetails.dart';

class ComplaintsManagement extends StatelessWidget {
  const ComplaintsManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الشكاوى والاستفسارات'),
        backgroundColor: Color(0xFF94A96B),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "قائمة الشكاوى",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: complaints.length, // عدد الشكاوى في القائمة
                itemBuilder: (context, index) {
                  final complaint = complaints[index]; // نموذج الشكوى
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        complaint['subject']?.toString() ?? 'لا يوجد عنوان',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "من: ${complaint['user']?.toString() ?? 'غير معروف'}\n${complaint['date']?.toString() ?? ''}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ComplaintDetails(complaint: complaint),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// بيانات الشكاوى (نموذج مؤقت)
final complaints = [
  {
    'id': 1,
    'user': 'Fatima Ahmed',
    'subject': 'تأخير في الطلب',
    'details': 'الطلب تأخر أكثر من يومين عن الموعد المتوقع.',
    'date': '2024-11-20',
    'status': 'Pending',
  },
  {
    'id': 2,
    'user': 'Huda Ali',
    'subject': 'طلب مرفوض بدون سبب',
    'details': 'تم رفض طلبي دون إعلامي بسبب الرفض.',
    'date': '2024-11-18',
    'status': 'Resolved',
  },
];

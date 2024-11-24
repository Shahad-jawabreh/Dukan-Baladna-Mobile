import 'package:flutter/material.dart';

class NotificationsManagement extends StatelessWidget {
  const NotificationsManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الإشعارات'),
        backgroundColor: const Color(0xFF94A96B),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "إرسال إشعار",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "نوع الإشعار",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: "general",
                  child: Text("إشعار عام"),
                ),
                DropdownMenuItem(
                  value: "individual",
                  child: Text("إشعار فردي"),
                ),
              ],
              onChanged: (value) {
                // تحديث النوع المختار
              },
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                labelText: "عنوان الإشعار",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "محتوى الإشعار",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Visibility(
              // يمكن إخفاء هذا الحقل في حالة الإشعارات العامة
              visible: true, // اجعلها ديناميكية حسب نوع الإشعار
              child: TextField(
                decoration: const InputDecoration(
                  labelText: "المستخدم أو ست البيت (في حالة الإشعار الفردي)",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // تنفيذ الإرسال
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم إرسال الإشعار.')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF94A96B),
              ),
              child: const Text("إرسال"),
            ),
          ],
        ),
      ),
    );
  }
}

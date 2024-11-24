import 'package:flutter/material.dart';

class UserManagementPage extends StatelessWidget {
   UserManagementPage({Key? key}) : super(key: key);

  // قائمة المستخدمين للمثال، يمكنك استبدال هذه البيانات ببيانات حقيقية من قاعدة البيانات
  final List<Map<String, String>> users = [
    {'name': 'أحمد علي', 'email': 'ahmed@example.com', 'phone': '1234567890', 'status': 'مفعل'},
    {'name': 'فاطمة حسين', 'email': 'fatima@example.com', 'phone': '0987654321', 'status': 'غير مفعل'},
    {'name': 'علي محمد', 'email': 'ali@example.com', 'phone': '1122334455', 'status': 'مفعل'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المستخدمين'),
        backgroundColor: Color(0xFF94A96B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'قائمة المستخدمين',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  var user = users[index];
                  return ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text(user['name']!),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('البريد الإلكتروني: ${user['email']}'),
                        Text('رقم الهاتف: ${user['phone']}'),
                        Text('الحالة: ${user['status']}'),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'activate') {
                          _changeStatus(context, user['name']!, 'مفعل');
                        } else if (value == 'deactivate') {
                          _changeStatus(context, user['name']!, 'غير مفعل');
                        } else if (value == 'delete') {
                          _deleteUser(context, user['name']!);
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'activate',
                          child: Text('تفعيل الحساب'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'deactivate',
                          child: Text('تعطيل الحساب'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('حذف الحساب'),
                        ),
                      ],
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

  // دالة لتغيير حالة الحساب (تفعيل/تعطيل)
  void _changeStatus(BuildContext context, String userName, String status) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$userName - تغيير الحالة'),
          content: Text('هل ترغب في تغيير حالة الحساب إلى "$status"؟'),
          actions: [
            TextButton(
              onPressed: () {
                // يمكنك هنا تحديث حالة الحساب في قاعدة البيانات
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم تغيير حالة الحساب إلى "$status"')),
                );
              },
              child: const Text('نعم'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('لا'),
            ),
          ],
        );
      },
    );
  }

  // دالة لحذف المستخدم
  void _deleteUser(BuildContext context, String userName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$userName - حذف الحساب'),
          content: const Text('هل أنت متأكد أنك ترغب في حذف هذا الحساب؟'),
          actions: [
            TextButton(
              onPressed: () {
                // يمكنك هنا تنفيذ عملية حذف المستخدم من قاعدة البيانات
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم حذف الحساب بنجاح')),
                );
              },
              child: const Text('نعم'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('لا'),
            ),
          ],
        );
      },
    );
  }
}

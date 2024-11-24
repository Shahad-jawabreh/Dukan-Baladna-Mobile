import 'package:flutter/material.dart';

class HouseholdCooksManagementPage extends StatelessWidget {
HouseholdCooksManagementPage({Key? key}) : super(key: key);

  // قائمة ستات البيوت كمثال
  final List<Map<String, String>> cooks = [
    {
      'name': 'طباخة فاطمة',
      'email': 'fatima@example.com',
      'phone': '1234567890',
      'status': 'مفعل',
      'image': 'assets/cook1.jpg',
      'foodImage': 'assets/food1.jpg',
      'rating': '4.5',
      'commission': '15%',
    },
    {
      'name': 'طباخة إيمان',
      'email': 'eman@example.com',
      'phone': '0987654321',
      'status': 'غير مفعل',
      'image': 'assets/cook2.jpg',
      'foodImage': 'assets/food2.jpg',
      'rating': '4.8',
      'commission': '18%',
    },
    // أضف المزيد من الطباخات هنا
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة ستات البيوت'),
        backgroundColor: Color(0xFF94A96B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'قائمة ستات البيوت',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: cooks.length,
                itemBuilder: (context, index) {
                  var cook = cooks[index];
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(cook['image']!),
                      ),
                      title: Text(cook['name']!),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('البريد الإلكتروني: ${cook['email']}'),
                          Text('رقم الهاتف: ${cook['phone']}'),
                          Text('التقييم: ${cook['rating']}'),
                          Text('العمولة: ${cook['commission']}'),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'approve') {
                            _approveCook(context, cook['name']!);
                          } else if (value == 'block') {
                            _blockCook(context, cook['name']!);
                          } else if (value == 'viewDetails') {
                            _viewCookDetails(context, cook);
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'approve',
                            child: Text('موافقة الحساب'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'block',
                            child: Text('حظر الحساب'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'viewDetails',
                            child: Text('عرض التفاصيل'),
                          ),
                        ],
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

  void _approveCook(BuildContext context, String cookName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$cookName - الموافقة على الحساب'),
          content: const Text('هل ترغب في الموافقة على هذا الحساب؟'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تمت الموافقة على الحساب')),
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

  void _blockCook(BuildContext context, String cookName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$cookName - حظر الحساب'),
          content: const Text('هل أنت متأكد أنك ترغب في حظر هذا الحساب؟'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم حظر الحساب')),
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

  void _viewCookDetails(BuildContext context, Map<String, String> cook) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تفاصيل ${cook['name']}'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(cook['foodImage']!),
                const SizedBox(height: 10),
                Text('التقييم: ${cook['rating']}'),
                const SizedBox(height: 10),
                Text('العمولة: ${cook['commission']}'),
                const SizedBox(height: 10),
                Text('البريد الإلكتروني: ${cook['email']}'),
                const SizedBox(height: 10),
                Text('رقم الهاتف: ${cook['phone']}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('إغلاق'),
            ),
          ],
        );
      },
    );
  }
}

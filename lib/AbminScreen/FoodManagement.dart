import 'package:flutter/material.dart';

class FoodManagement extends StatelessWidget {
  FoodManagement({Key? key}) : super(key: key);

  // قائمة الأكلات كمثال
  final List<Map<String, String>> foods = [
    {
      'name': 'كبسة دجاج',
      'image': 'assets/food1.jpg',
      'price': '50',
      'cook': 'طباخة فاطمة',
    },
    {
      'name': 'مقلوبة باذنجان',
      'image': 'assets/food2.jpg',
      'price': '40',
      'cook': 'طباخة إيمان',
    },
    // أضف المزيد من الأكلات هنا
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الأكلات'),
        backgroundColor: Color(0xFF94A96B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'قائمة الأكلات',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  var food = foods[index];
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: Image.asset(
                        food['image']!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(food['name']!),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('السعر: ${food['price']}'),
                          Text('الطباخة: ${food['cook']}'),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _editFood(context, food['name']!);
                          } else if (value == 'delete') {
                            _deleteFood(context, food['name']!);
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: Text('تعديل الأكلة'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Text('حذف الأكلة'),
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

  void _editFood(BuildContext context, String foodName) {
    // عرض نافذة تعديل الأكلة
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تعديل الأكلة: $foodName'),
          content: const Text('يمكنك تعديل تفاصيل الأكلة هنا.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم تعديل الأكلة بنجاح')),
                );
              },
              child: const Text('تعديل'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('إلغاء'),
            ),
          ],
        );
      },
    );
  }

  void _deleteFood(BuildContext context, String foodName) {
    // عرض نافذة حذف الأكلة
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('حذف الأكلة: $foodName'),
          content: const Text('هل أنت متأكد من أنك ترغب في حذف هذه الأكلة؟'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم حذف الأكلة بنجاح')),
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

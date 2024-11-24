import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:dukan_baladna/screens/globle.dart';
import 'package:flutter/material.dart';
import 'OngoingOrder.dart'; // استيراد صفحة OngoingOrders
import 'PastOrders.dart'; // استيراد صفحة PastOrderPage
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
class OrdersPage extends StatefulWidget {
  
  const OrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
 List<dynamic> pendingOrders = []; // تغيير الاسم إلى pendingOrders
bool isLoading = true;
String errorMessage = '';

int _selectedTabIndex = 0; // افتراض التبويب الأول هو "New Orders"

@override
void initState() {
  super.initState();
  fetchPendingOrders(); // استدعاء الدالة الجديدة
}

Future<void> fetchPendingOrders() async {
  const apiUrl = 'https://dukan-baladna.onrender.com/order/all';
  print(token);
  try {
    // إعداد Headers مع المصادقة
    final headers = {
      'Authorization': 'brear_$token', // المصادقة
      'Content-Type': 'application/json',
    };

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers, // إضافة headers
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body); // فك تشفير JSON
      final orders = data['orders']; // الحصول على قائمة الطلبات
      List<dynamic> filteredOrders = []; // قائمة للطلبات المفلترة

      for (var order in orders) {
        if (order['status'] == "pending") {
          filteredOrders.add(order); // إضافة الطلبات ذات الحالة pending
        }
      }
      print("Filtered Orders:");
      print(filteredOrders);

      setState(() {
        pendingOrders = filteredOrders; // تحديث الحالة
        isLoading = false; // إيقاف حالة التحميل
      });
    } else {
      setState(() {
        errorMessage = 'Failed to load pending orders. Please try again later.';
        isLoading = false;
      });
    }
  } catch (e) {
    setState(() {
      errorMessage = 'Error: $e';
      isLoading = false;
    });
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("New Orders"),
      backgroundColor: const Color(0xFF94A96B),
      centerTitle: true,
    ),
    body: Column(
      children: [
        Container(
          color: const Color(0xFF94A96B),
          child: Row(
            children: [
              buildTab("New Orders", 0, context),
              buildTab("Ongoing Orders", 1, context),
              buildTab("Past Orders", 2, context),
            ],
          ),
        ),
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
                  ? Center(child: Text(errorMessage))
                  : ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: pendingOrders.length,
                      itemBuilder: (context, index) {
                        final order = pendingOrders[index];
                        return buildOrderCard(order);
                      },
                    ),
        ),
      ],
    ),
  );
}
  // تصميم التبويبات
  Widget buildTab(String title, int index, BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OngoingOrders()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PastOrders()),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            color: index == 0 ? Colors.white : Color(0xFF94A96B),
            border: index == 0
                ? const Border(
                    bottom: BorderSide(
                      color: Color(0xFF94A96B),
                      width: 2.0,
                    ),
                  )
                : null,
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: index == 0 ? Color(0xFF94A96B) : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
String formatOrderDate(String? createdAt) {
  if (createdAt == null || createdAt.isEmpty) {
    return 'Unknown time';
  }

  try {
    // Parse the API-provided date string
    DateTime dateTime = DateTime.parse(createdAt);

    // Format it to show date and hour
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);

    return formattedDate;
  } catch (e) {
    // Handle any parsing errors
    return 'Invalid date';
  }
}

Future<void> cancelOrder(String orderId) async {
    
    final apiUrl = 'https://dukan-baladna.onrender.com/order/changeStatus/$orderId';

    final url = Uri.parse(apiUrl);
    
    // Create the body with the status you want to change to
    final body = json.encode({
      'status': 'cancelled', // Set the status to "accepted"
    });
    // Send the POST request to change the status
    try {
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'brear_$token',
          'Content-Type': 'application/json',
        },
        body: body,
      );
      if (response.statusCode == 200) {
      print("Order cancel successfully.");
      Fluttertoast.showToast(
      msg: "Order cancel successfully." ,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
      // Find and remove the order from the list
      setState(() {
        pendingOrders.removeWhere((order) => order['_id'] == orderId);
      });
    } else {
      print('Failed to accept order: ${response.body}');
    }
    } catch (e) {
      print('Error occurred while accepting order: $e');
    }
  }
 // Function to handle the "Accept" button press
  Future<void> acceptOrder(String orderId) async {
    
    final apiUrl = 'https://dukan-baladna.onrender.com/order/changeStatus/$orderId';

    final url = Uri.parse(apiUrl);
    
    // Create the body with the status you want to change to
    final body = json.encode({
      'status': 'confirmed', // Set the status to "accepted"
    });
    // Send the POST request to change the status
    try {
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'brear_$token',
          'Content-Type': 'application/json',
        },
        body: body,
      );
      if (response.statusCode == 200) {
      print("Order accepted successfully.");

      Fluttertoast.showToast(
      msg: "Order accepted successfully.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
      // Find and remove the order from the list
      setState(() {
        pendingOrders.removeWhere((order) => order['_id'] == orderId);
      });
    } else {
      print('Failed to accept order: ${response.body}');
    }
    } catch (e) {
      print('Error occurred while accepting order: $e');
    }
  }
  // تصميم بطاقة الطلب
 Widget buildOrderCard(Map<String, dynamic> order) {
return Card(
    margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
    elevation: 6,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 222, 224, 241),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order['userName'] ?? 'Unknown Customer',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                "Order ID: ${order['orderNum'] ?? 'N/A'}",
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            "Phone: ${order['phoneNumber'] ?? 'N/A'}",
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black87,
            ),
          ),
          Text(
            "Address: ${order['address'] ?? 'N/A'}",
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 12.0),

          // Order Date
          Text(
            formatOrderDate(order['createdAt'] ?? 'Unknown time'),
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
          const Divider(height: 24.0, thickness: 1.0),

          // Product Details
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order['products']?.length ?? 0,
            itemBuilder: (context, index) {
              final item = order['products'][index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['name'] ?? 'Unknown Item',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "Qty: ${item['quantity'] ?? 0} | \$${item['unitPrice'] ?? 0.0}",
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(height: 24.0, thickness: 1.0),

          // Final Price
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Final Price: \$${order['finalPrice'] ?? 0.0}",
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
                    const SizedBox(height: 16.0),
   Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.phone, size: 18),
                label: const Text("Call"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              ),
              
              ElevatedButton.icon(
                onPressed: () {
                      final orderId = order['_id']?.toString();
                      if (orderId == null || orderId.isEmpty) {
                        print('Error: orderId is null or empty');
                        return;
                      }
                      cancelOrder(orderId);
                },
                icon: const Icon(Icons.cancel, size: 18),
                label: const Text("Cancel"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
              ElevatedButton.icon(
                onPressed: () {
                      final orderId = order['_id']?.toString();
                      if (orderId == null || orderId.isEmpty) {
                        print('Error: orderId is null or empty');
                        return;
                      }
                      acceptOrder(orderId);
                },
                icon: const Icon(Icons.check_circle, size: 18),
                label: const Text("Accept"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}}

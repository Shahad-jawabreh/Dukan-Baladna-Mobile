import 'package:dukan_baladna/screens/globle.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http; // For API requests
import 'package:intl/intl.dart';

import 'PastOrderDetails.dart'; // Details page
import 'OngoingOrder.dart'; // Ongoing orders page
import 'OrdersPage.dart'; // New orders page

class PastOrders extends StatefulWidget {
  const PastOrders({Key? key}) : super(key: key);

  @override
  _PastOrdersState createState() => _PastOrdersState();
}

class _PastOrdersState extends State<PastOrders> {
  List<dynamic> pastOrders = [];  // Change to List<dynamic>
  bool isLoading = true;
  String errorMessage = '';

  int _selectedTabIndex = 2;

  @override
  void initState() {
    super.initState();
    fetchPastOrders();
  }

  Future<void> fetchPastOrders() async {
    const apiUrl = 'https://dukan-baladna.onrender.com/order/all';
    print(token);
    try {
      // إعداد Headers مع المصادقة
      final headers = {
        'Authorization': 'brear_$token', // Fixed: correct the authorization key.
        'Content-Type': 'application/json',
      };

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: headers, // Adding headers here
      );
      
      print(response.body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body); // Decode JSON response
        final orders = data['orders']; // Access 'order' field from the response
        List<dynamic> filteredOrders = []; // List to store filtered orders

        for (var order in orders) {
        
          if (order['status'] == "cancelled" || order['status'] == "delivered") {
            filteredOrders.add(order); // Add matching orders to the list
          }
        }
     
        setState(() {
          pastOrders = filteredOrders; // Update state with filtered orders
          isLoading = false; // Set loading state to false
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load past orders. Please try again later.';
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
        title: const Text("Past Orders"),
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
                        itemCount: pastOrders.length,
                        itemBuilder: (context, index) {
                          final order = pastOrders[index];
                          return buildOrderCard(order, context);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget buildTab(String title, int index, BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
          if (index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersPage()));
          } else if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => OngoingOrders()));
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            color: _selectedTabIndex == index ? Colors.white : const Color(0xFF94A96B),
            border: _selectedTabIndex == index
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
                color: _selectedTabIndex == index ? const Color(0xFF94A96B) : Colors.white,
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
  Widget buildOrderCard(dynamic order, BuildContext context) {
      return Card(
    margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order['userName'] ?? 'Unknown',
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
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),

          // Order Date
          Text(
            formatOrderDate(order['createdAt'] ?? 'Unknown time'),
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.grey,
            ),
          ),
          const Divider(height: 24.0, thickness: 1.0),

         

          // Order Status and Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
            "Status: ${order['status'] ?? 'Pending'}",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: order['status'] == 'delivered' ? Colors.green : Colors.red,
            ),

              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PastOrderDetails(order: order),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.orange,
                ),
                icon: const Icon(Icons.arrow_forward, size: 16.0),
                label: const Text("View Details"),
              ),
            ],
          ),
        ],
      ),
    ),
  );
  }
}
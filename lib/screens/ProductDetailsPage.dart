import 'package:dukan_baladna/screens/cart.dart';
import 'package:dukan_baladna/screens/login.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'globle.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productId;

  const ProductDetailsPage({required this.productId, Key? key}) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  Map<String, dynamic>? productDetails;
  bool isLoading = true;
  String? errorMessage;
  

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }



  Future<void> fetchProductDetails() async {
    final apiUrl = "https://dukan-baladna.onrender.com/product/info/${widget.productId}";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          productDetails = json.decode(response.body)['product'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "فشل تحميل تفاصيل المنتج. يرجى المحاولة مرة أخرى.";
          isLoading = false;
        });
      }
      if (token != '') {
      try {
        // Fetch the cart count asynchronously
        final cartCountValue = await numberOfItemInsideCart(userId);
        setState(() {
          cartCount = cartCountValue; // Assign the resolved value
        });
      } catch (e) {
         print(e);
      }
    }
    } catch (e) {
      setState(() {
        errorMessage = "حدث خطأ: $e";
        isLoading = false;
      });
    }
  }

Future<int> numberOfItemInsideCart(String userId) async {
  final cartApiUrl = "https://dukan-baladna.onrender.com/cart/$userId";
  try {
    final response = await http.get(
      Uri.parse(cartApiUrl),
      headers: {
        'Authorization': 'brear_$token', // Fixed typo: 'brear_' -> 'Bearer_'
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['cart'] != null && data['cart'].isNotEmpty) {
        final products = data['cart'][0]['products']; // Access the first cart's 'products'
         int count = 0;
        for (int i = 0; i < products.length; i++) {
          // Ensure 'quantity' exists and is an integer
          if (products[i]['quantity'] != null) {
            count += (products[i]['quantity'] as int); // Explicitly cast to int
          }
        }
        return count ?? 0; // Return the length, defaulting to 0 if null
      } else {
        return 0; // Return 0 if no cart exists
      }
    } else {
      // Log or handle unexpected status codes
      throw Exception('Failed to fetch cart items. Status code: ${response.statusCode}');
    }
  } catch (e) {
    // Add logging or error tracking here if needed
    throw Exception('Error fetching cart items: $e');
  }
}

Future<void> addToCart(String userId, String productId, {int quantity = 1}) async {
  try {
    if (token == null || token!.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => login()), // Redirect to login page
      );
      return;
    }

    final data = {
      'productId': productId,
      'quantity': quantity,
    };

    final response = await http.post(
      Uri.parse('https://dukan-baladna.onrender.com/cart'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'brear_$token', // Fixed typo: 'brear_' -> 'Bearer_'
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        cartCount++; // Increment the cart count
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added to cart successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      final errorData = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorData['message'] ?? 'Failed to add to cart. Please try again!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('An error occurred. Please try again!'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  @override
Widget build(BuildContext context) {
  if (isLoading) {
    return Scaffold(
      appBar: AppBar(
        title: Text('جاري التحميل...'),
        backgroundColor: Color(0xFF94A96B),
      ),
      body: Center(child: CircularProgressIndicator()),
    );
  }
  setState(() {
    cartCount; // Increment the cart count
  });
  if (errorMessage != null) {
    return Scaffold(
      appBar: AppBar(
        title: Text('خطأ'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Text(
          errorMessage!,
          style: TextStyle(color: Colors.red, fontSize: 18.0),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // Default main image
  String mainImage = productDetails!['mainImage']['secure_url'];

  return Scaffold(
    appBar: AppBar(
      title: Text(productDetails!['name']),
      backgroundColor: Color(0xFF94A96B),
      elevation: 0,
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartPage()), // Navigate to the cart page
                );
              },
            ),
            if (cartCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.red,
                  child: Text(
                    '$cartCount',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
      ],
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الصورة الرئيسية
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                mainImage,
                height: 250.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16.0),

            // الصور المصغرة
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // إضافة الصورة الرئيسية كصورة مصغرة
                GestureDetector(
                  onTap: () {
                    setState(() {
                      mainImage = productDetails!['mainImage']['secure_url'];
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        productDetails!['mainImage']['secure_url'],
                        height: 100.0,
                        width: 100.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // الصور الفرعية
                ...((productDetails!['subImage'] as List).map((subImage) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        mainImage = subImage['secure_url'];
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          subImage['secure_url'],
                          height: 100.0,
                          width: 100.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }).toList()),
        ],
      ),

            SizedBox(height: 16.0),

            // Product name and details
            Text(
              productDetails!['name'],
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "السعر: ${productDetails!['price']} ₪",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: Colors.teal[600],
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              "الوصف:",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF94A96B),
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              productDetails!['description'] ?? "لا يوجد وصف متوفر",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 16.0, color: Colors.grey[800]),
            ),
            SizedBox(height: 24.0),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.favorite_border),
                    label: Text("إضافة إلى الأمنيات"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF94A96B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      addToCart(userId, productDetails!['_id']);
                    },
                    icon: Icon(Icons.shopping_cart),
                    label: Text("إضافة إلى السلة"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF6FB7A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
}
import 'dart:io';

import 'package:dukan_baladna/screens/cart.dart';
import 'package:dukan_baladna/screens/login.dart';
import 'package:image_picker/image_picker.dart';
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
    TextEditingController commentController = TextEditingController();
  String? imagePath;
  bool isImagePicked = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
        isImagePicked = true;
      });
      } else {
        print('pickedFile = null');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
    
  }
  

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

  final List<Map<String, dynamic>> reviews = [
  {
    'name': 'محمد',
    'image': 'assets/chef1.jpg', // Store image path as a String
    'date': '10 نوفمبر 2024',
    'rating': 5,
    'comment': 'منتج رائع جدًا!',
    'reply': 'شكراً لتعليقك الجميل!'
  },
  {
    'name': 'علي',
    'image': 'assets/chef2.jpg', // Store image path as a String
    'date': '9 نوفمبر 2024',
    'rating': 3,
    'comment': 'المنتج جيد ولكنه يحتاج لتحسين.',
    'reply': 'شكراً لملاحظاتك، سنعمل على تحسينه!'
  },
  {
    'name': 'فاطمة',
    'image': 'assets/chef3.jpg', // Store image path as a String
    'date': '8 نوفمبر 2024',
    'rating': 4,
    'comment': 'جودة ممتازة.',
    'reply': 'نشكرك على تعليقك!'
  },
];


  // القيمة الحالية للفلتر
  int? selectedRating;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredReviews = selectedRating == null
        ? reviews
        : reviews.where((review) => review['rating'] == selectedRating).toList();

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('جاري التحميل...'),
          backgroundColor: Color(0xFF94A96B),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

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

    String mainImage = productDetails!['mainImage']['secure_url'];

    return Scaffold(
      appBar: AppBar(
        title: Text(productDetails!['name']),
        backgroundColor: Color(0xFF94A96B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main image and thumbnails
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
              // Product details
              Text(
                productDetails!['name'],
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800],
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                "السعر: ${productDetails!['price']} ₪",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal[600],
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                "الوصف:",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF94A96B),
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                productDetails!['description'] ?? "لا يوجد وصف متوفر",
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
              SizedBox(height: 24.0),

              // Add comment with image
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('أضف تعليقًا مع صورة:'),
                  TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: 'اكتب تعليقك هنا...',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.camera_alt),
                    label: Text('اختيار صورة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF94A96B),
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                    ),
                  ),
                  if (isImagePicked && imagePath != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Image.file(
                        File(imagePath!),
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 24.0),

              // Rating filter
              Row(
                children: [
                  Text(
                    'تصفية حسب التقييم:',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(width: 10),
                  DropdownButton<int?>(
                    value: selectedRating,
                    hint: Text('الكل'),
                    items: [
                      DropdownMenuItem(value: null, child: Text('الكل')),
                      DropdownMenuItem(value: 5, child: Text('5 نجوم')),
                      DropdownMenuItem(value: 4, child: Text('4 نجوم')),
                      DropdownMenuItem(value: 3, child: Text('3 نجوم')),
                      DropdownMenuItem(value: 2, child: Text('2 نجوم')),
                      DropdownMenuItem(value: 1, child: Text('1 نجمة')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedRating = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Reviews
              filteredReviews.isEmpty
                  ? Center(
                      child: Text(
                        'لا توجد مراجعات بهذا التقييم.',
                        style: TextStyle(fontSize: 18.0, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filteredReviews.length,
                      itemBuilder: (context, index) {
                        final review = filteredReviews[index];
                        return Card(
                          margin: EdgeInsets.only(bottom: 16.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
          backgroundImage: NetworkImage('https://res.cloudinary.com/dlqd05svw/image/upload/v1731309403/dukan_baladna/user/cejbupvonnulvjk0hf3i.jpg'),
                                      radius: 25,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          review['name'],
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          review['date'],
                                          style: TextStyle(color: Colors.grey, fontSize: 12.0),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Text(
                                      '⭐' * review['rating'],
                                      style: TextStyle(color: Colors.orange, fontSize: 16.0),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(
                                  review['comment'],
                                  style: TextStyle(fontSize: 14.0),
                                ),
                                if (review['image'] != null) ...[
                                  SizedBox(height: 10),
                                  Image.network(
                                    'https://res.cloudinary.com/dlqd05svw/image/upload/v1731309403/dukan_baladna/user/cejbupvonnulvjk0hf3i.jpg',
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ],
                                if (review['reply'] != null) ...[
                                  SizedBox(height: 10),
                                  Text(
                                    'رد: ${review['reply']}',
                                    style: TextStyle(fontSize: 13.0, color: Colors.blueGrey),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dukan_baladna/screens/loginAndsiginup.dart';
import 'package:dukan_baladna/screens/profilePage.dart';
import 'package:dukan_baladna/screens/category.dart';
import 'globle.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}



// Updated FoodItem class to include additional information
class FoodItem {
  final String imageUrl;
  final String name;
  final String price;
  final String description; // Add a description field
  final List<String> ingredients; // Add an ingredients list

  FoodItem({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.description,
    required this.ingredients,
  });
}

// Define the list of best-selling items
final List<FoodItem> bestSellerItems = [
  FoodItem(
    imageUrl: 'assets/dawali.png', // Replace with your actual image URL
    name: 'Dawali',
    price: '\$20.00',
    description: 'Delicious ramen with rich broth and fresh toppings.',
    ingredients: ['Noodles', 'Pork', 'Egg', 'Seaweed', 'Green Onions'],
  ),
  FoodItem(
    imageUrl: 'assets/humus.png', // Provide a valid image URL
    name: 'Humus',
    price: '\$25.00',
    description: 'Spicy ramen with extra chili oil and vegetables.',
    ingredients: ['Noodles', 'Chicken', 'Egg', 'Spices', 'Vegetables'],
  ),
  FoodItem(
    imageUrl: 'assets/mkhlal.png', // Provide a valid image URL
    name: 'Mkhlal',
    price: '\$25.00',
    description: 'Spicy ramen with extra chili oil and vegetables.',
    ingredients: ['Noodles', 'Chicken', 'Egg', 'Spices', 'Vegetables'],
  ),
  // Add more items as needed
];

class _HomePageState extends State<HomePage> {
    var userId = null ;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;


  @override
  void initState() {
    super.initState();
    // Set up the timer to change the page every 2 seconds
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      _currentPage = (_currentPage + 1) % bestSellerItems.length;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _showLoginSignupDialog(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => loginAndsignup()),
  );
}

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Color.fromARGB(255, 52, 121, 40),
      title: Row(
        children: [
         IconButton(
            icon: const Icon(Icons.dashboard, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryPage()),
              );
            },
          ),

          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                hintText: 'Search here...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              if (isLogin) {
                // Navigate to the profile page if the user is logged in
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(), // Assuming you have a ProfilePage widget
                  ),
                );
              } else {
                // Navigate to the login/signup page if not logged in
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => loginAndsignup(), // Assuming you have a login/signup widget
                  ),
                );
              }
            },
            child:isLogin 
                ? CircleAvatar(
                    backgroundImage: userProfileImage.isNotEmpty
                        ? NetworkImage(userProfileImage)
                        : AssetImage(userProfileImage) as ImageProvider,
                    radius: 20,
                  ) 
                : Icon(
                    Icons.login, 
                    color: Colors.white,
                  ),

                          
          ),
        ],
      ),
    ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carousel Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: [
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: PageView(
                      controller: _pageController,
                      children: [
                        _buildCarouselSlide(
                          imagePath: 'assets/back.png',   
                          title: "Free Delivery Order!",
                          description: "Order from the top chef and get free delivery.",
                        ),
                        _buildCarouselSlide(
                          imagePath: 'assets/back4.png',   
                          title: "Special Discount!",
                          description: "Get 20% off on all orders above \$50.",
                        ),
                        _buildCarouselSlide(
                          imagePath: 'assets/mm.png',   
                          title: "Seasonal Food!",
                          description: "Try our seasonal best-selling dishes.",
                        ),
                      ],
                    ),
                  ),
                  // Navigation Arrows
                  _buildCarouselArrow(
                    icon: Icons.arrow_back_ios,
                    onPressed: () {
                      setState(() {
                        _currentPage = (_currentPage - 1 + bestSellerItems.length) % bestSellerItems.length;
                        _pageController.animateToPage(
                          _currentPage,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      });
                    },
                    alignment: Alignment.centerLeft,
                  ),
                  _buildCarouselArrow(
                    icon: Icons.arrow_forward_ios,
                    onPressed: () {
                      setState(() {
                        _currentPage = (_currentPage + 1) % bestSellerItems.length;
                        _pageController.animateToPage(
                          _currentPage,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      });
                    },
                    alignment: Alignment.centerRight,
                  ),
                ],
              ),
            ),

            // Best Chefs Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Text("Best Chefs", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                children: [
                  _buildChefCard("assets/chef1.jpg", "Chef Fatima"),
                  _buildChefCard("assets/chef2.jpg", "Chef Eman"),
                  _buildChefCard("assets/chef3.jpg", "Chef C"),
                  _buildChefCard("assets/chef4.jpg", "Chef A"),
                  // Add more chefs here
                ],
              ),
            ),

            // Best Seller Food Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Text("Best Seller", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              padding: const EdgeInsets.all(16),
              itemCount: bestSellerItems.length,
              itemBuilder: (context, index) {
                final item = bestSellerItems[index];
                return FoodItemCard(
                  title: item.name,
                  price: item.price,
                  imageUrl: item.imageUrl,
                  description: item.description,
                  ingredients: item.ingredients,
                  onTap: () => _showFoodDetails(context, item),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

Widget _buildCarouselSlide({
  required String imagePath,
  required String title,
  required String description,
}) {
  return Stack(
    children: [
      // الخلفية (الصورة)
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
      // الطبقة الشفافة
      Container(
        color: Colors.black.withOpacity(0.5), // لون أسود شفاف
      ),
      // النصوص
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}



  Widget _buildCarouselArrow({required IconData icon, required VoidCallback onPressed, required Alignment alignment}) {
    return Align(
      alignment: alignment,
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildChefCard(String imagePath, String chefName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(imagePath),
          radius: 30,
        ),
        const SizedBox(height: 8),
        Text(chefName),
      ],
    );
  }

  void _showFoodDetails(BuildContext context, FoodItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(item.imageUrl, height: 100, fit: BoxFit.cover),
              const SizedBox(height: 10),
              Text(item.description),
              const SizedBox(height: 10),
              const Text("Ingredients:", style: TextStyle(fontWeight: FontWeight.bold)),
              for (var ingredient in item.ingredients) Text(ingredient),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}

class FoodItemCard extends StatelessWidget {
  final String title;
  final String price;
  final String imageUrl;
  final String description;
  final List<String> ingredients;
  final VoidCallback onTap;

  const FoodItemCard({
    Key? key,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.ingredients,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(imageUrl, height: 120, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(price, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }
}


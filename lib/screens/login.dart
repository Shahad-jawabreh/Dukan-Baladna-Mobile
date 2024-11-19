import 'dart:convert'; 
import 'package:dukan_baladna/screens/loginAndsiginup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home_page.dart';
import 'package:dukan_baladna/screens/ForgotPasswordPage.dart';
import 'signup.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; 
import 'globle.dart'; 
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class login extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  bool rememberMe = false;

  String? usernameError;
  String? passwordError;

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token'); 

    if (token != null) {
      try {
        final jwt = JWT.verify(token, SecretKey('123456#'));
        userId = jwt.payload['_id'];
        print('User ID: $userId'); 
        setState(() {
          isLogin = true;
        });
      } catch (e) {
        print('Error decoding token: $e');
      }
    } else {
      print('No token found');
    }
  }

  Future<void> _login() async {
    setState(() {
      isLoading = true;
      usernameError = null;
      passwordError = null;
    });

    final url = Uri.parse('https://dukan-baladna.onrender.com/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': _usernameController.text,
        'password': _passwordController.text,
      }),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      token= responseData['token'];
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('auth_token', token);

      // Load token after successful login
      _loadToken();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } else {
      final responseData = jsonDecode(response.body);
      final errorMessage = responseData['message'] ?? 'Login failed.';
      
      setState(() {
        if (errorMessage.contains("password")) {
          passwordError = "Incorrect password.";
        } else if (errorMessage.contains("username") || errorMessage.contains("email")) {
          usernameError = "Incorrect username or email.";
        } else {
          usernameError = "Login failed. Please check your credentials.";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 52, 121, 40),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                 Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => loginAndsignup()),
                      );
              },
            ),
            SizedBox(height: 20),
            Text(
              'Hi !\nWelcome Back,',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username, Email or Phone Number',
                labelStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                errorText: usernameError,
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: Icon(Icons.visibility, color: Colors.grey),
                errorText: passwordError,
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: rememberMe,
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value!;
                        });
                      },
                      activeColor: Color(0xFFF9E79F),
                    ),
                    Text(
                      'Remember Me',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Color(0xFFF9E79F)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF9E79F),
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.black)
                    : Text(
                        'LOGIN',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => signup()),
                      );
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(color: Color(0xFFF9E79F)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
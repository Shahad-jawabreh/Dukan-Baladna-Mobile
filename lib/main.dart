import 'package:flutter/material.dart';
import 'firebase_options.dart'; // Ensure this file exists and is correctly configured
import 'service/push_notification.dart'; // Correct path to PushNotificationService
import 'screens/welcome_screen.dart'; // Correct path to your WelcomePage

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();

  // // Initialize Firebase (ensure only one initialization)
  // if (Firebase.apps.isEmpty) {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  // }

  // // Initialize Push Notification Service
  // await PushNotificationService.init();

  // Run the application
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Roboto', // Set global font for the app
      ),
      home: const WelcomePage(), // Ensure WelcomePage is a valid widget
    );
  }
}

import 'package:flutter/material.dart';
import 'auth/login.dart';
import 'auth/signup_page.dart';
import 'screens/navigation_screen.dart'; // Import NavigationScreen
import 'home.dart';
// import 'package:firebase_core/firebase_core.dart';
//import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is ready before Firebase
  //await dotenv.load(); // Load environment variables
  runApp(const TRADERSPLAYGROUND());
}

class TRADERSPLAYGROUND extends StatelessWidget {
  const TRADERSPLAYGROUND({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: '/',  // Fix: Set login as the first screen
      routes: {
        '/': (context) => LoginPage(),
        //'/login':(contect) => 
        '/signup': (context) => SignUpPage(),
        '/home': (context) => NavigationScreen(),
        '/home1': (context) => Home(), // Fix: Use NavigationScreen instead of Home()
      },
    );
  }
}

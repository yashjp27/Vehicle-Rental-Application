import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'LoginPage.dart'; // Import your LoginPage.dart file
import 'RegisterPage.dart';
import 'pages/add_vehicles.dart';
import 'dart:ui' as ui;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyD6Fqdci61hBbEXkFFznjbYIZI-Kvj_Mtc",
        appId: "1:601864833610:web:388dfd21a1b9e3cb5034b3",
        messagingSenderId: "601864833610",
        projectId: "vehicle-rental-2",
      ),
    );
  }

  await Firebase.initializeApp();
  await addVehiclesToFirestore();
  Stripe.publishableKey = 'pk_test_51MiBiVSCK0Ri6tc5Qepg1CycGGwtNbInH3vC5eeYfnqJIgI6j1ZRivugGdcxPhR3EZogYhCv0musGOfiwhhMfQxu005UD0ZMle';
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentWordIndex = 0;
  List<String> words = ['Smoother', 'Faster', 'Comfortable'];

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        currentWordIndex = (currentWordIndex + 1) % words.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(), // Use the common app bar
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/car_image.jpeg'), // Use the car image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100.0),
                Image.asset(
                  'assets/logo_1.jpg', // Add your logo image here
                  width: 400, // Adjust the width as needed
                ),
                SizedBox(height: 20.0),
                AnimatedDefaultTextStyle(
                  duration: Duration(seconds: 1),
                  style: TextStyle(
                    fontSize: 48.0,
                    fontFamily: 'YourCustomFont',
                    color: Colors.blue,
                    shadows: <Shadow>[
                      Shadow(
                        blurRadius: 8.0,
                        color: Colors.amber,
                      ),
                    ],
                  ),
                  child: Text('Welcome to Vehicle Rental'),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedSwitcher(
                      duration: Duration(seconds: 1),
                      child: Text(
                        'To Make Vehicle Rentals',
                        style: TextStyle(
                          fontSize: 36.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                        key: Key(words[currentWordIndex]),
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Text(
                      words[currentWordIndex],
                      style: TextStyle(
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HoverButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text('Login'),
                    ),
                    SizedBox(width: 20.0),
                    HoverButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterForm()),
                        );
                      },
                      child: Text('Register'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        'Vehicle Rental',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/logo_website.jpg',
            width: 50.0,
            height: 50.0,
          ),
        ),
      ],
    );
  }
}

class HoverButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  HoverButton({
    required this.onPressed,
    required this.child,
  });

  @override
  _HoverButtonState createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (isHovered) {
        setState(() {
          _isHovered = isHovered;
        });
      },
      onTap: widget.onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: _isHovered ? Colors.amber : Colors.blue,
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: EdgeInsets.all(12.0),
        child: widget.child,
      ),
    );
  }
}

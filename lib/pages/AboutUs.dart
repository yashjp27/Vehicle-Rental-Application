import 'package:flutter/material.dart';

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  int selectedPersonIndex = -1; // Initially, no person is selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.purple], // Blue to violet gradient
          ),
        ),
        child: ListView(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildGlowingText(
                  'Welcome to Vehicle Rental Application',
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  colors: [Colors.white, Colors.yellow],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
              child: Text(
                'Description:',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
              child: Text(
                'Welcome to our Vehicle Rental Application, your one-stop solution for all your transportation needs. We offer a wide range of high-quality vehicles, from cars and motorcycles to trucks and vans, for your convenience. Whether it\'s a short commute or a long road trip, our vehicles are well-maintained and ready to meet your travel requirements. With competitive pricing and easy booking, we make renting a vehicle a hassle-free experience. Discover the freedom of reliable transportation with us today!',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
                child: _buildGlowingText(
                  'Our Team',
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  colors: [Colors.white, Colors.yellow],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildPersonContainer(
                  'Nikson Nadar',
                  '20',
                  'https://firebasestorage.googleapis.com/v0/b/vehicle-rental-2.appspot.com/o/vehicle_images%2Fnikson.jpg?alt=media&token=e63675b8-9d71-43a3-b6a4-9cb85e9ee3c6',
                  0, // Index for Nikson
                ),
                _buildPersonContainer(
                  'Rushabh Patel',
                  '20',
                  'https://firebasestorage.googleapis.com/v0/b/vehicle-rental-2.appspot.com/o/vehicle_images%2Frushabh.jpg?alt=media&token=2fbdea04-5b82-464e-8d0f-cf52354ecd0f',
                  1, // Index for Rushabh
                ),
                _buildPersonContainer(
                  'Yash Parmar',
                  '20',
                  'https://firebasestorage.googleapis.com/v0/b/vehicle-rental-2.appspot.com/o/vehicle_images%2Fyash.jpg?alt=media&token=397fae82-0ea4-4450-bd8a-8faa85676b9e',
                  2, // Index for Yash
                ),
                _buildPersonContainer(
                  'Omkar Parab',
                  '20',
                  'https://firebasestorage.googleapis.com/v0/b/vehicle-rental-2.appspot.com/o/vehicle_images%2Fomkar.jpg?alt=media&token=e841bcb5-4f5e-4e2b-b2a6-551eb9dff51a',
                  3, // Index for Omkar
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlowingText(
      String text, {
        double fontSize = 24.0,
        FontWeight fontWeight = FontWeight.normal,
        List<Color> colors = const [Colors.black, Colors.white],
      }) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          shadows: colors.map((color) {
            return Shadow(
              color: color,
              offset: Offset(0, 0),
              blurRadius: 10.0,
            );
          }).toList(),
        ),
        children: [
          TextSpan(
            text: text,
            style: TextStyle(
              color: colors.first,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonContainer(String name, String age, String imageUrl, int index) {
    final isSelected = index == selectedPersonIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          // Toggle the selection of the person
          if (isSelected) {
            selectedPersonIndex = -1;
          } else {
            selectedPersonIndex = index;
          }
        });
      },
      child: Container(
        width: 200.0,
        height: 300.0,
        color: Colors.grey,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            // Image with opacity based on the selection
            Opacity(
              opacity: isSelected ? 0.5 : 1.0,
              child: Image.network(
                imageUrl,
                width: double.infinity, // Occupies the entire width of the container
                height: double.infinity, // Occupies the entire height of the container
                fit: BoxFit.cover, // Maintain aspect ratio while covering the entire space
              ),
            ),
            // Name and age details when selected
            if (isSelected)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Name: $name',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Age: $age',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Vehicle Rental App'),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              ListTile(
                title: Text('Home'),
                onTap: () {
                  // Navigate to the home page
                },
              ),
              ListTile(
                title: Text('About Us'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutUsPage()),
                  );
                },
              ),
              // Add more items to the drawer as needed
            ],
          ),
        ),
        // Add other main content and functionality of your app
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

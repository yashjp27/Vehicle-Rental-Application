import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vehicle/pages/VehicleSearch2Page.dart';
import 'VehicleSearchPageRent.dart';

class VehicleDetailsPage extends StatelessWidget {
  final String vehicleName;
  final String userName;
  final String userEmail;

  VehicleDetailsPage({
    required this.vehicleName,
    required this.userName,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Searched Vehicles'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.pinkAccent],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: _buildGlowingText('Searched Vehicles'),
            ),
            Expanded(
              child: VehicleDetailsWidget(
                vehicleName: vehicleName,
                userName: userName,
                userEmail: userEmail,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlowingText(
      String text, {
        double fontSize = 38.0,
        FontWeight fontWeight = FontWeight.bold,
        List<Color> colors = const [Colors.white, Colors.pinkAccent],
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
}

class VehicleDetailsWidget extends StatefulWidget {
  final String vehicleName;
  final String userName;
  final String userEmail;

  VehicleDetailsWidget({
    required this.vehicleName,
    required this.userName,
    required this.userEmail,
  });

  @override
  _VehicleDetailsWidgetState createState() => _VehicleDetailsWidgetState();
}

class _VehicleDetailsWidgetState extends State<VehicleDetailsWidget> {
  Map<String, dynamic>? vehicleData;

  @override
  void initState() {
    super.initState();
    // Fetch vehicle details and update the state
    fetchVehicleDetails();
  }

  void fetchVehicleDetails() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    firestore
        .collection('vehicles')
        .where('name', isEqualTo: widget.vehicleName)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data() as Map<String, dynamic>?;
        setState(() {
          vehicleData = data;
        });
      }
    }).catchError((error) {
      print('Error fetching vehicle details: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (vehicleData == null) {
      // Display a loading indicator while fetching data
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return SingleChildScrollView(
        child: _buildVehicleDetails(vehicleData!),
      );
    }
  }

  Widget _buildVehicleDetails(Map<String, dynamic> data) {
    double rating = data['Ratings'] ?? 0.0;
    print("Ratings : $rating");

    Widget buildStars() {
      List<Widget> stars = [];
      int fullStars = rating.floor();
      double fractionStar = rating - fullStars;

      // Full stars
      for (int i = 0; i < fullStars; i++) {
        stars.add(
          Container(
            width: 24.0, // Adjust the size as needed
            height: 24.0, // Adjust the size as needed
            decoration: BoxDecoration(),
            child: Icon(
              Icons.star,
              color: Colors.blue,
              size: 20.0, // Adjust the size as needed
            ),
          ),
        );
      }

      // Partial star
      if (fractionStar > 0.0) {
        stars.add(
          Container(
            width: 24.0, // Adjust the size as needed
            height: 24.0, // Adjust the size as needed
            decoration: BoxDecoration(),
            child: ClipRect(
              clipper: FractionalClipper(fractionStar),
              child: Icon(
                Icons.star,
                color: Colors.blue,
                size: 20.0, // Adjust the size as needed
              ),
            ),
          ),
        );
      }

      int emptyStars = 5 - fullStars - (fractionStar > 0.0 ? 1 : 0);
      for (int i = 0; i < emptyStars; i++) {
        stars.add(
          Container(
            width: 24.0, // Adjust the size as needed
            height: 20.0, // Adjust the size as needed
            decoration: BoxDecoration(),
            child: Icon(
              Icons.star,
              color: Colors.grey,
              size: 20.0, // Adjust the size as needed
            ),
          ),
        );
      }

      return Row(
        children: stars,
      );
    }


    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Vehicle Image (rounded from all corners)
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 300,
              height: 200,
              child: Image.network(
                data['imageUrl'] ?? '',
                width: 300,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Vehicle Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['name'] ?? '',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Price per hour: \₹${data['pricePerHour'] ?? 0.0}',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Price per day: \₹${data['pricePerDay'] ?? 0.0}',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Vehicle Type: ${data['type'] ?? 'Car'}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  // Star Ratings
                  buildStars(),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      print("User : ${widget.userName}");
                      print("Email : ${widget.userEmail}");
                      /* Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              VehicleSearch2Page(
                                userName: widget.userName,
                                userEmail: widget.userEmail,
                                name: data['name']?? '',
                                imageUrl: data['imageUrl']?? '',
                                pricePerHour: data['pricePerHour']?? 0.0,
                                pricePerDay:  data['pricePerDay']?? 0.0,
                                vehicleType: data['vehicleType']?? '',
                                pickupLocation: data['pickupLocation']?? '',
                                dropOffLocation: data['dropOffLocation']?? '',
                              ),
                        ),
                      ); */
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      ),
                      elevation: MaterialStateProperty.all<double>(0),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    child: Text(
                      'Rent Now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FractionalClipper extends CustomClipper<Rect> {
  final double fraction;

  FractionalClipper(this.fraction);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width * fraction, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return fraction != (oldClipper as FractionalClipper).fraction;
  }
}

import 'package:flutter/material.dart';
import 'IntroPage.dart';
import 'VehicleSearchPageRent.dart';
import 'package:flutter_gif/flutter_gif.dart';

class TrendingVehiclesPage extends StatelessWidget {
  final String userName;
  final String userEmail;

  TrendingVehiclesPage({
    required  this.userName,
    required this.userEmail,
});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trending Vehicles'),
      ),
      body: Stack(
        children: [
          // Background GIF
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.network(
              'https://firebasestorage.googleapis.com/v0/b/vehicle-rental-2.appspot.com/o/gif%2F434102179035201.gif?alt=media&token=0cd8da0b-9b2c-4d51-8ee8-8197aabb7738&_gl=1*2wigvt*_ga*MzU3MjE5ODMxLjE2OTQwODQwODY.*_ga_CW55HF8NVT*MTY5NjQwNTQ0OC43MC4xLjE2OTY0MDYyMzEuNTMuMC4w',
              fit: BoxFit.cover,
            ),
          ),

          // Content on top of the GIF
          Column(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Trending Vehicles',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Set the text color to white
                    shadows: [
                      Shadow(
                        blurRadius: 6.0,
                        color: Colors.orange,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: trendingVehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = trendingVehicles[index];
                    return _buildVehicleCard(vehicle, context, userName, userEmail);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

List<Vehicle> trendingVehicles = [
    Vehicle(
      name: 'Volvo VNX',
      imageUrl:
      'https://firebasestorage.googleapis.com/v0/b/vehicle-rental-2.appspot.com/o/vehicle_images%2Fvehicle_95.jpeg?alt=media&token=bf514c1a-90bb-4eed-a23c-4627a67b2678', // Replace with actual image URL
      rating: 4.3,
      pricePerHour: 349,
      pricePerDay: 3270,
      vehicleType: 'Truck',
    ),
    Vehicle(
      name: 'Mercedes E-class',
      imageUrl:
      'https://firebasestorage.googleapis.com/v0/b/vehicle-rental-2.appspot.com/o/vehicle_images%2Fvehicle_22.webp?alt=media&token=108a7ad7-caa3-4743-b267-89d1d1ff3866', // Replace with actual image URL
      rating: 5.0,
      pricePerHour: 280,
      pricePerDay: 2790,
      vehicleType: 'Car',
    ),
    Vehicle(
      name: 'Prevost H3-45',
      imageUrl:
      'https://firebasestorage.googleapis.com/v0/b/vehicle-rental-2.appspot.com/o/vehicle_images%2Fvehicle_42.jpeg?alt=media&token=2adcd9a3-60fb-4edb-a43b-b604537630b7', // Replace with actual image URL
      rating: 4.0,
      pricePerHour: 285,
      pricePerDay: 3000,
      vehicleType: 'Bus',
    ),
    Vehicle(
      name: 'Gillig Low Floor',
      imageUrl:
      'https://firebasestorage.googleapis.com/v0/b/vehicle-rental-2.appspot.com/o/vehicle_images%2Fvehicle_43.jpg?alt=media&token=c8f92c27-ac3b-473a-bc4b-c113aba61e77', // Replace with actual image URL
      rating: 4.2,
      pricePerHour: 285,
      pricePerDay: 3000,
      vehicleType: 'Bus',
    ),
    Vehicle(
      name: 'Kia Seltos',
      imageUrl:
      'https://firebasestorage.googleapis.com/v0/b/vehicle-rental-2.appspot.com/o/vehicle_images%2Fvehicle_83.png?alt=media&token=23893052-9162-4a56-9f7b-d798804cddd4', // Replace with actual image URL
      rating: 4.1,
      pricePerHour: 349,
      pricePerDay: 3270,
      vehicleType: 'Car',
    ),
    Vehicle(
      name: 'Honda Civic',
      imageUrl:
      'https://firebasestorage.googleapis.com/v0/b/vehicle-rental-2.appspot.com/o/vehicle_images%2Fvehicle_10.jpeg?alt=media&token=73945bbf-740c-443e-8222-e62de3caf407', // Replace with actual image URL
      rating: 3.5,
      pricePerHour: 230,
      pricePerDay: 2399,
      vehicleType: 'Car',
    ),
    Vehicle(
      name: 'Nissan Rogue',
      imageUrl:
      'https://firebasestorage.googleapis.com/v0/b/vehicle-rental-2.appspot.com/o/vehicle_images%2Fvehicle_80.jpeg?alt=media&token=0e6612f6-bf06-4cdd-aeb5-20aaa43f86ad', // Replace with actual image URL
      rating: 4.7,
      pricePerHour: 349,
      pricePerDay: 3270,
      vehicleType: 'Car',
    ),
    Vehicle(
      name: 'Hyundai Tucson',
      imageUrl:
      'https://firebasestorage.googleapis.com/v0/b/vehicle-rental-2.appspot.com/o/vehicle_images%2Fvehicle_79.jpeg?alt=media&token=bd30fa43-5659-4083-8459-af3120d279c0', // Replace with actual image URL
      rating: 4.6,
      pricePerHour: 329,
      pricePerDay: 3370,
      vehicleType: 'Car',
    ),
    Vehicle(
      name: 'Porsche 911',
      imageUrl:
      'https://firebasestorage.googleapis.com/v0/b/vehicle-rental-2.appspot.com/o/vehicle_images%2Fvehicle_32.jpeg?alt=media&token=96fcb616-e665-441d-a417-b8a4735f6ac4', // Replace with actual image URL
      rating: 5,
      pricePerHour: 285,
      pricePerDay: 3000,
      vehicleType: 'Car',
    ),

    Vehicle(
      name: 'Tesla Model S',
      imageUrl:
      'https://firebasestorage.googleapis.com/v0/b/vehicle-rental-2.appspot.com/o/vehicle_images%2Fvehicle_88.webp?alt=media&token=005d667e-9861-4a0e-981b-125b3b91af39', // Replace with actual image URL
      rating: 4.3,
      pricePerHour: 349,
      pricePerDay: 3270,
      vehicleType: 'Car',
    ),
    Vehicle(
      name: ' Alexander Dennis Enviro400',
      imageUrl:
      'https://firebasestorage.googleapis.com/v0/b/vehicle-rental-2.appspot.com/o/vehicle_images%2Fvehicle_98.jpg?alt=media&token=d286d497-ee09-4aec-b778-2699dfe4c530', // Replace with actual image URL
      rating: 4.4,
      pricePerHour: 349,
      pricePerDay: 3270,
      vehicleType: 'Bus',
    ),
    Vehicle(
      name: 'Mack Granite',
      imageUrl:
      'https://firebasestorage.googleapis.com/v0/b/vehicle-rental-2.appspot.com/o/vehicle_images%2Fvehicle_96.jpeg?alt=media&token=53e92a91-bc4b-4179-bdb7-49ef663d8387', // Replace with actual image URL
      rating: 3.9,
      pricePerHour: 349,
      pricePerDay: 3270,
      vehicleType: 'Truck',
    ),

    Vehicle(
      name: 'BMW C 650 GT',
      imageUrl:
      'https://firebasestorage.googleapis.com/v0/b/vehicle-rental-2.appspot.com/o/vehicle_images%2Fvehicle_50.jpeg?alt=media&token=2a6e2b18-3013-4171-b787-f05bf1775ae5', // Replace with actual image URL
      rating: 4.6,
      pricePerHour: 285,
      pricePerDay: 3000,
      vehicleType: 'Scooter',
    ),

    Vehicle(
      name: 'KTM 1290 Super Duke R',
      imageUrl:
      'https://firebasestorage.googleapis.com/v0/b/vehicle-rental-2.appspot.com/o/vehicle_images%2Fvehicle_66.webp?alt=media&token=5b2ecfb6-a632-4a50-be49-cd141beef782', // Replace with actual image URL
      rating: 4.6,
      pricePerHour: 285,
      pricePerDay: 3000,
      vehicleType: 'Motorbike',
    ),

    Vehicle(
      name: 'Scania OmniExpress',
      imageUrl:
      'https://firebasestorage.googleapis.com/v0/b/vehicle-rental-2.appspot.com/o/vehicle_images%2Fvehicle_37.jpeg?alt=media&token=8ae48090-6424-4a41-851b-78e2baeb6ddf', // Replace with actual image URL
      rating: 4,
      pricePerHour: 285,
      pricePerDay: 3000,
      vehicleType: 'Bus',
    ),
    Vehicle(
      name: 'Hyundai Sonata',
      imageUrl:
      'https://firebasestorage.googleapis.com/v0/b/vehicle-rental-2.appspot.com/o/vehicle_images%2Fvehicle_24.jpeg?alt=media&token=ba79f9dc-c685-4ff9-816a-366860782f06', // Replace with actual image URL
      rating: 4.1,
      pricePerHour: 240,
      pricePerDay: 2450,
      vehicleType: 'Car',
    ),

    Vehicle(
      name: 'Mazda3',
      imageUrl:
      'https://firebasestorage.googleapis.com/v0/b/vehicle-rental-2.appspot.com/o/vehicle_images%2Fvehicle_84.jpeg?alt=media&token=b4c0ed94-743e-4033-8fa9-cff9de2de7b9', // Replace with actual image URL
      rating: 4.4,
      pricePerHour: 349,
      pricePerDay: 3270,
      vehicleType: 'Car',
    ),

    Vehicle(
      name: 'TATA 328S',
      imageUrl:
      'https://firebasestorage.googleapis.com/v0/b/vehicle-rental-2.appspot.com/o/vehicle_images%2Fvehicle_72.jpg?alt=media&token=0f51ceba-3056-41ac-bfef-e4a3d95a0d0c', // Replace with actual image URL
      rating: 4.2,
      pricePerHour: 285,
      pricePerDay: 3000,
      vehicleType: 'Truck',
    ),

    Vehicle(
      name: 'Land Rover DiscoveryE',
      imageUrl:
      'https://firebasestorage.googleapis.com/v0/b/vehicle-rental-2.appspot.com/o/vehicle_images%2Fvehicle_34.jpeg?alt=media&token=0e6e8bbf-896c-4c8a-8051-b11029c28198', // Replace with actual image URL
      rating: 3.4,
      pricePerHour: 285,
      pricePerDay: 3000,
      vehicleType: 'Car',
    ),
    Vehicle(
      name: 'Chevrolet Equinox',
      imageUrl:
      'https://firebasestorage.googleapis.com/v0/b/vehicle-rental-2.appspot.com/o/vehicle_images%2Fvehicle_78.jpeg?alt=media&token=280955ff-b374-4624-be09-efd4089034e9', // Replace with actual image URL
      rating: 4.7,
      pricePerHour: 389,
      pricePerDay: 3170,
      vehicleType: 'Car',
    ),
    // Add more vehicles here
  ];

  Widget _buildVehicleCard(Vehicle vehicle, BuildContext context,String userName,String userEmail) {
    Color starColor;
    if (vehicle.rating >= 5.0) {
      starColor = Colors.yellow;
    } else if (vehicle.rating >= 4.0) {
      starColor = Colors.blue;
    } else if (vehicle.rating >= 3.0) {
      starColor = Colors.black;
    } else {
      starColor = Colors.white; // You can set a default color if needed.
    }

    // Function to build star icons
    Widget buildStars() {
      List<Widget> stars = [];
      int fullStars = vehicle.rating.floor();
      double fractionStar = vehicle.rating - fullStars;

      // Full stars
      for (int i = 0; i < fullStars; i++) {
        stars.add(
          Icon(
            Icons.star,
            color: starColor,
          ),
        );
      }

      // Partial star (if needed)
      if (fractionStar > 0.0 && fullStars < 5) {
        stars.add(
          Icon(
            Icons.star_half,
            color: starColor,
          ),
        );
        fullStars++;
      }

      // Empty stars
      for (int i = fullStars; i < 5; i++) {
        stars.add(
          Icon(
            Icons.star_border,
            color: Colors.grey,
          ),
        );
      }

      return Row(
        children: stars,
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      elevation: 4,
      child: Row(
        children: [
          // Left side with the vehicle image
          Container(
            width: 300,
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(vehicle.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Right side with vehicle details and "Rent Now" button
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicle.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Vehicle Type: ${vehicle.vehicleType}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Rating: ',
                        style: TextStyle(fontSize: 16),
                      ),
                      buildStars(), // Add star icons here
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\₹${vehicle.pricePerDay.toStringAsFixed(2)} / day',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\₹${vehicle.pricePerHour.toStringAsFixed(2)} / hour',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => VehicleSearchPageRent(
                              userName: userName, // Pass the userName
                              userEmail: userEmail, // Pass the userEmail
                              name: vehicle.name, // Pass the vehicle name
                              imageUrl: vehicle.imageUrl,
                              pricePerHour: vehicle.pricePerHour,
                              pricePerDay: vehicle.pricePerDay,
                              vehicleType: vehicle.vehicleType,

                            ),
                          )
                      );
                    },
                    child: Text('Rent Now'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


class Vehicle {
  final String name;
  final String imageUrl;
  final double rating;
  final int pricePerHour;
  final int pricePerDay;
  final String vehicleType;

  Vehicle({
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.pricePerHour,
    required this.pricePerDay,
    required this.vehicleType,
  });
}

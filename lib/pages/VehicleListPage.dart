import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'VehicleSearchPageRent.dart';

class VehicleListPage extends StatelessWidget {
  final List<String> matchingVehicleNames;
  final String userName;
  final String userEmail;

  VehicleListPage({required this.matchingVehicleNames, required this.userName, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Filtered Vehicles'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.pinkAccent],
          ),
        ),
        child: VehicleListWidget(
            matchingVehicleNames: matchingVehicleNames,
          userName: userName,
          userEmail: userEmail,
        ),
      ),
    );
  }
}

class VehicleListWidget extends StatefulWidget {
  final List<String> matchingVehicleNames;
  final String userName;
  final String userEmail;

  VehicleListWidget({
    required this.matchingVehicleNames,
    required this.userName,
    required this.userEmail,
  });

  @override
  _VehicleListWidgetState createState() => _VehicleListWidgetState();
}

class _VehicleListWidgetState extends State<VehicleListWidget> {
  List<Widget> vehicleList = [];

  @override
  void initState() {
    super.initState();
    // Fetch vehicle details and update the list
    fetchVehicleDetails();
  }

  void fetchVehicleDetails() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    List<Widget> vehicles = [];

    for (String vehicleName in widget.matchingVehicleNames) {
      firestore
          .collection('vehicles')
          .where('name', isEqualTo: vehicleName)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          var data = querySnapshot.docs.first.data() as Map<String, dynamic>;

          Widget vehicleWidget = buildVehicleWidget(data);
          vehicles.add(vehicleWidget);

          if (widget.matchingVehicleNames.last == vehicleName) {
            // If it's the last vehicle, update the state with the combined list
            setState(() {
              vehicleList = vehicles;
            });
          }
        }
      }).catchError((error) {
        print('Error fetching vehicle details: $error');
      });
    }
  }


  Widget buildVehicleWidget(Map<String, dynamic> data) {
    return Stack(
      children: [
        Container(
          // Vehicle card
          height: 230,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            // Vehicle details
            children: [
              Container(
                margin: EdgeInsets.only(left: 10, top: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    data['imageUrl'] ?? '',
                    width: 350,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        data['name'] ?? '',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              print("User : ${widget.userName}");
                              print("Email : ${widget.userEmail}");
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => VehicleSearchPageRent(
                                    userName: widget.userName,
                                    userEmail: widget.userEmail,
                                    name: data['name'],
                                    imageUrl: data['imageUrl'],
                                    pricePerHour: data['pricePerHour'],
                                    pricePerDay: data['pricePerDay'],
                                    vehicleType: data['type'],
                                  ),
                                ),
                              );
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
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          right: 0,
          child: Divider(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: vehicleList,
    );
  }
}

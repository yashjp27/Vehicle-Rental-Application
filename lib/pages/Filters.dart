import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'VehicleListPage.dart';

String selectedVehicleType = 'Car';
double selectedPriceMin = 0;
double selectedPriceMax = 1000;
int selectedPassengers = 1;
double selectedCustomerRating = 0;

class FilterPage extends StatefulWidget {
  final String userName;
  final String userEmail;

  FilterPage({
   required this.userName,
   required this.userEmail,
});

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String selectedVehicleType = 'Car';
  double selectedPriceMin = 0;
  double selectedPriceMax = 1000;
  int selectedPassengers = 1;
  double selectedCustomerRating = 0;
  List<String> matchingVehicleNames = [];


  final CollectionReference filtersCollection = FirebaseFirestore.instance
      .collection('filters');
  final CollectionReference vehiclesCollection = FirebaseFirestore.instance
      .collection('vehicles');

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Filter data added successfully to Firestore.'),
    ));
  }

  void showNoVehiclesFoundDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Vehicles Found'),
          content: Text(
              'No vehicles found for your applied filters 😔 Please try again with different filters.'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }


  Future<void> displayVehiclesByPriceRange() async {
    try {
      QuerySnapshot priceQuery = await vehiclesCollection
          .where('pricePerHour', isGreaterThanOrEqualTo: selectedPriceMin)
          .where('pricePerHour', isLessThanOrEqualTo: selectedPriceMax)
          .where('type', isEqualTo: selectedVehicleType)
          .get();

      QuerySnapshot passengersQuery = await vehiclesCollection
          .where('Passengers', isGreaterThanOrEqualTo: selectedPassengers)
          .get();

      QuerySnapshot ratingsQuery = await vehiclesCollection
          .where('Ratings', isGreaterThanOrEqualTo: selectedCustomerRating)
          .get();


      Set<String> priceSet = Set.from(
          priceQuery.docs.map((doc) => doc['name'] as String));
      Set<String> passengersSet = Set.from(
          passengersQuery.docs.map((doc) => doc['name'] as String));
      Set<String> ratingsSet = Set.from(
          ratingsQuery.docs.map((doc) => doc['name'] as String));

      Set<String> commonVehicles = priceSet.intersection(passengersSet)
          .intersection(ratingsSet);

      List<String> vehicleNames = commonVehicles.toList();
      print(
          'Vehicle names within the price range, with passengers and ratings conditions: $vehicleNames');
      if (vehicleNames.isEmpty) {
        showNoVehiclesFoundDialog(context);
      }
      else {
        setState(() {
          matchingVehicleNames = vehicleNames;
        });
      }
    } catch (e) {
      print('Error querying vehicles: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<String>(
              value: selectedVehicleType,
              onChanged: (value) {
                setState(() {
                  selectedVehicleType = value!;
                });
              },
              items: [
                'Car',
                'Motorbike',
                'Cycle',
                'Bus',
                'Truck',
                'Scooter'
              ]
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'Price Range (per hour): \₹$selectedPriceMin - \₹$selectedPriceMax'),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedPriceMin = 0;
                      selectedPriceMax = 1000;
                    });
                  },
                  child: Text('Reset'),
                ),
              ],
            ),
            RangeSlider(
              values: RangeValues(selectedPriceMin, selectedPriceMax),
              onChanged: (values) {
                setState(() {
                  selectedPriceMin = values.start;
                  selectedPriceMax = values.end;
                });
              },
              min: 0,
              max: 1000,
              divisions: 100,
              labels: RangeLabels('\₹$selectedPriceMin', '\₹$selectedPriceMax'),
            ),
            SizedBox(height: 16),

            Text('Number of Passengers: $selectedPassengers'),
            Slider(
              value: selectedPassengers.toDouble(),
              onChanged: (value) {
                setState(() {
                  selectedPassengers = value.round();
                });
              },
              min: 1,
              max: 20,
              divisions: 19,
              // Create 19 divisions for passengers from 1 to 20
              label: selectedPassengers.toString(),
            ),
            SizedBox(height: 16),

            // Customer Ratings Slider
            Text('Customer Ratings: ${selectedCustomerRating.toStringAsFixed(1)}'),
            Slider(
              value: selectedCustomerRating,
              onChanged: (value) {
                setState(() {
                  selectedCustomerRating = value;
                });
              },
              min: 0,
              max: 5,
              divisions: 49,
              label: (selectedCustomerRating.toDouble().toStringAsFixed(1)),
            ),
            SizedBox(height: 16),

            // Reset and Apply Filters buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedPriceMin = 0;
                      selectedPriceMax = 1000;
                      selectedCustomerRating = 0;
                      selectedPassengers = 1;
                      selectedVehicleType = 'Car';
                    });
                  },
                  child: Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (matchingVehicleNames.isNotEmpty) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              VehicleListPage(matchingVehicleNames: matchingVehicleNames,
                              userName: widget.userName,
                                  userEmail: widget.userEmail),
                        ),
                      );
                    } else {
                      // Handle applying filters and showing a message when no vehicles are found
                      Map<String, dynamic> filterData = {
                        'vehicleType': selectedVehicleType,
                        'priceMin': selectedPriceMin,
                        'priceMax': selectedPriceMax,
                        'passengers': selectedPassengers,
                        'customerRating': selectedCustomerRating,
                      };

                      try {
                        await filtersCollection.add(filterData);
                        _showSuccessMessage();
                        await displayVehiclesByPriceRange();
                      } catch (e) {
                        print('Error adding filter data: $e');
                      }

                      // After applying filters, check for matching vehicles
                      if (matchingVehicleNames.isEmpty) {
                        showNoVehiclesFoundDialog(context);
                      }
                    }
                  },
                  child: Text('Apply Filters'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

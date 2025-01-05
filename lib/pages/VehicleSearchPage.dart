import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'search_results_form.dart';
import 'RentPage.dart';
import 'package:firebase_core/firebase_core.dart';

class VehicleSearchPage extends StatefulWidget {

  final String userName ;
  final String userEmail ;

  VehicleSearchPage({
    required this.userName,
    required this.userEmail,
});
  @override
  _VehicleSearchPageState createState() => _VehicleSearchPageState();
}

class SearchDetails {
  final DateTime pickupDate;
  final DateTime dropOffDate;
  final TimeOfDay pickupTime;
  final TimeOfDay dropOffTime;
  final List<String> pickupLocation; // Changed from List<String> to String
  final List<String> dropOffLocation; // Changed from List<String> to String

  SearchDetails({
    required this.pickupDate,
    required this.dropOffDate,
    required this.pickupTime,
    required this.dropOffTime,
    required this.pickupLocation,
    required this.dropOffLocation,
  });
}

class _VehicleSearchPageState extends State<VehicleSearchPage> {
  String selectedVehicleType = 'Car';
  DateTime? pickupDate;
  DateTime? dropOffDate;
  TimeOfDay? pickupTime;
  TimeOfDay? dropOffTime;
  List<String> pickupLocation = [];
  List<String> dropOffLocation = [];
  String brand = '';
  String pickname = '';
  String dropname = '';

  List<Map<String, dynamic>> searchResults = [];

  Future<void> _adddetails() async {
    try {
      // Initialize Firebase if not already initialized
      await Firebase.initializeApp();

      // Reference the Firestore collection
      CollectionReference<Map<String, dynamic>> collectionRef =
      FirebaseFirestore.instance.collection('search_form');

      // Create an instance of SearchDetails and populate it with user data
      SearchDetails searchDetails = SearchDetails(
        pickupDate: pickupDate!,
        dropOffDate: dropOffDate!,
        pickupTime: pickupTime!,
        dropOffTime: dropOffTime!,
        pickupLocation: pickupLocation, // Store pickup location as a string
        dropOffLocation: dropOffLocation, // Store drop-off location as a string
      );

      // Convert TimeOfDay values to strings
      String pickupTimeStr =
          '${searchDetails.pickupTime!.hour}:${searchDetails.pickupTime!.minute}';
      String dropOffTimeStr =
          '${searchDetails.dropOffTime!.hour}:${searchDetails.dropOffTime!.minute}';


      final int documentId = await _getNextDocumentId(collectionRef);


      await collectionRef.doc(documentId.toString()).set({
        'pickupDate': searchDetails.pickupDate,
        'dropOffDate': searchDetails.dropOffDate,
        'pickupTime': pickupTimeStr,
        'dropOffTime': dropOffTimeStr,
        'pickupLocation': pickname,
        'dropOffLocation': dropname,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Log a success message
      print('Details with ID $documentId added successfully to Firestore.');

      // Your existing code to execute the query and display search results...
    } catch (error) {
      // Print the error message for debugging
      print('Error during adding details to Firestore: $error');
    }
  }


// Function to get the next available document ID
  Future<int> _getNextDocumentId(CollectionReference<Map<String, dynamic>> collectionRef) async {
    int nextId = 1;
    QuerySnapshot<Map<String, dynamic>> snapshot = await collectionRef.get();
    snapshot.docs.forEach((doc) {
      int? docId = int.tryParse(doc.id);
      if (docId != null && docId >= nextId) {
        nextId = docId + 1;
      }
    });
    return nextId;
  }


  Future<void> _handleSearch() async {
    try {
      // Build the Firestore query based on user input
      CollectionReference<Map<String, dynamic>> collectionRef = FirebaseFirestore.instance.collection('vehicles');
      Query<Map<String, dynamic>> query = collectionRef; // Start with the collection reference

      if (selectedVehicleType.isNotEmpty) {
        query = query.where('type', isEqualTo: selectedVehicleType);
      }

      if (pickupLocation.isEmpty) {
        print ('Pickup Location : $pickupLocation');
      }

      if (pickupLocation.isNotEmpty) {
        print ('Pickup Location : $pickupLocation');
        query = query.where('pickupLocation', isEqualTo: pickupLocation);
      }

      if (dropOffLocation.isNotEmpty) {
        query = query.where('dropOffLocation', isEqualTo: dropOffLocation);
      }
      print('Selected Vehicle Type: $selectedVehicleType');

      // Execute the query and store the results
      final querySnapshot = await query.get();
      print('Number of matching documents: ${querySnapshot.docs.length}');

      // Convert DocumentSnapshot objects to List<Map<String, dynamic>>
      final resultsAsMaps = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      setState(() {
        searchResults = resultsAsMaps;
      });

      await _adddetails();

      // Create a copy of pickupLocation and dropOffLocation lists without duplicates
      final distinctPickupLocation = pickupLocation.toSet().toList();
      final distinctDropOffLocation = dropOffLocation.toSet().toList();

      DateTime? pickdate = pickupDate;
      DateTime? dropdate = dropOffDate;

      // Create an instance of SearchDetails and populate it with user data
      SearchDetails searchDetails = SearchDetails(
        pickupDate: pickupDate!,
        dropOffDate: dropOffDate!,
        pickupTime: pickupTime!,
        dropOffTime: dropOffTime!,
        pickupLocation: distinctPickupLocation, // Store distinct pickup locations
        dropOffLocation: distinctDropOffLocation, // Store distinct drop-off locations
      );
      String pickupTimeStr =
          '${searchDetails.pickupTime!.hour}:${searchDetails.pickupTime!.minute}';
      String dropOffTimeStr =
          '${searchDetails.dropOffTime!.hour}:${searchDetails.dropOffTime!.minute}';
      // Navigate to the SearchResultsForm page with the matched vehicle details
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsForm(searchResults, searchDetails,
          widget.userName,
          widget.userEmail, pickdate!, pickupTimeStr,
            pickname,
            dropdate!,
            dropOffTimeStr,
            dropname,
          ),
        ),
      );
    } catch (error) {
      print('Error during search: $error');
    }
  }


  // Define the _selectTime method
  Future<void> _selectTime(BuildContext context, TimeOfDay? initialTime, Function(TimeOfDay) onTimeSelected) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
    );

    if (selectedTime != null) {
      onTimeSelected(selectedTime);
    }
  }

// Define the _selectPickupDate method
  Future<void> _selectPickupDate(BuildContext context) async {
    final currentDate = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: pickupDate ?? currentDate,
      firstDate: currentDate,
      lastDate: currentDate.add(Duration(days: 365)), // Allow booking up to a year in advance
    );

    if (selectedDate != null) {
      setState(() {
        pickupDate = selectedDate;
      });
    }
  }

// Define the _selectDropOffDate method
  Future<void> _selectDropOffDate(BuildContext context) async {
    final currentDate = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: dropOffDate ?? currentDate,
      firstDate: currentDate,
      lastDate: currentDate.add(Duration(days: 365)), // Allow booking up to a year in advance
    );

    if (selectedDate != null) {
      setState(() {
        dropOffDate = selectedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vehicle Rental Application',
          style: TextStyle(
            fontFamily: 'YourCustomFont',
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Vehicle Search",
                  style: TextStyle(
                    color: Colors.blue,
                    fontFamily: 'YourCustomFont',
                    fontSize: 24.0,
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Pick-up Time"),
                          SizedBox(height: 8.0),
                          GestureDetector(
                            onTap: () {
                              _selectTime(context, pickupTime, (time) {
                                setState(() {
                                  pickupTime = time;
                                });
                              });
                            },
                            child: Row(
                              children: [
                                Icon(Icons.access_time),
                                SizedBox(width: 8.0),
                                Text(
                                  pickupTime == null
                                      ? 'Select pick-up time'
                                      : '${pickupTime!.hour}:${pickupTime!.minute}',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Pick-up Date"),
                          SizedBox(height: 8.0),
                          InkWell(
                            onTap: () {
                              _selectPickupDate(context);
                            },
                            child: InputDecorator(
                              decoration: InputDecoration(
                                hintText: 'Select pick-up date',
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(
                                  Icons.calendar_today,
                                  color: Colors.blue,
                                ),
                              ),
                              child: Text(
                                pickupDate == null
                                    ? 'Select pick-up date'
                                    : '${pickupDate!.toLocal()}'
                                    .split(' ')[0],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Text("Pick-up Location"),
                SizedBox(height: 8.0),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      // Check if the entered value matches any location in the pickup locations list
                      bool matchesPickupLocation = pickupLocation.any((location) => location == value);
                      print ('Pickup : $value');
                      pickname = value;
                      print ('Latest : $pickname');

                      // If it matches pickup location, add it to the pickupLocations list
                      if (matchesPickupLocation) {
                        pickupLocation.add(value);
                      }
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter pickup location',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Drop-off Time"),
                          SizedBox(height: 8.0),
                          GestureDetector(
                            onTap: () {
                              _selectTime(context, dropOffTime, (time) {
                                setState(() {
                                  dropOffTime = time;
                                });
                              });
                            },
                            child: Row(
                              children: [
                                Icon(Icons.access_time),
                                SizedBox(width: 8.0),
                                Text(
                                  dropOffTime == null
                                      ? 'Select drop-off time'
                                      : '${dropOffTime!.hour}:${dropOffTime!.minute}',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Drop-off Date"),
                          SizedBox(height: 8.0),
                          InkWell(
                            onTap: () {
                              _selectDropOffDate(context);
                            },
                            child: InputDecorator(
                              decoration: InputDecoration(
                                hintText: 'Select drop-off date',
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(
                                  Icons.calendar_today,
                                  color: Colors.blue,
                                ),
                              ),
                              child: Text(
                                dropOffDate == null
                                    ? 'Select drop-off date'
                                    : '${dropOffDate!.toLocal()}'
                                    .split(' ')[0],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Text("Drop-off Location"),
                SizedBox(height: 8.0),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      // Check if the entered value matches any location in the drop-off locations list
                      bool matchesDropOffLocation = dropOffLocation.any((location) => location == value);
                      dropname = value;
                      print('Latest(drop) : $dropname');

                      // If it matches drop-off location, add it to the dropOffLocations list
                      if (matchesDropOffLocation) {
                        dropOffLocation.add(value);
                      }
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter drop-off location',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                Text("Vehicle Type"),
                SizedBox(height: 8.0),
                DropdownButton<String>(
                  value: selectedVehicleType,
                  onChanged: (String? value) {
                    setState(() {
                      selectedVehicleType = value ?? '';
                    });
                  },
                  items: <String>[
                    'Car',
                    'Motorbike',
                    'Cycle',
                    'Bus',
                    'Truck',
                    'Scooter',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  hint: Text("Select vehicle type"),
                ),
                SizedBox(height: 16.0),
                Text("Brand"),
                SizedBox(height: 8.0),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      brand = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter vehicle brand',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () {
                    _handleSearch();
                  },
                  child: Text('Search'),
                ),
                // Display search results
                if (searchResults.isNotEmpty) ...[
                  SizedBox(height: 16.0),
                  Text(
                    'Search Results:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Column(
                    children: searchResults.map((result) {
                      return ListTile(
                        title: Text(result['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Type: ${result['type']}'),
                            Text('Price per Hour: ${result['pricePerHour']}'),
                            Text('Price per Day: ${result['pricePerDay']}'),
                          ],
                        ),
                        // Add more details as needed
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

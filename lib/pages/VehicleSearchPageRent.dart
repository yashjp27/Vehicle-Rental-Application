import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'RentPage.dart';
import 'VehicleSearchPage.dart';
import 'package:flutter/widgets.dart';

class VehicleSearchPageRent extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String name;
  final String imageUrl;
  final int pricePerHour;
  final int pricePerDay;
  final String vehicleType;

  VehicleSearchPageRent({
    required this.userName,
    required this.userEmail,
    required this.name,
    required this.imageUrl,
    required this.pricePerHour,
    required this.pricePerDay,
    required this.vehicleType,
});

  @override
  _VehicleSearchPageRentState createState() => _VehicleSearchPageRentState();
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

class _VehicleSearchPageRentState extends State<VehicleSearchPageRent> {
  DateTime? pickupDate;
  DateTime? dropOffDate;
  TimeOfDay? pickupTime;
  TimeOfDay? dropOffTime;
  List<String> pickupLocation = [];
  List<String> dropOffLocation = [];
  late String pickname;
  late String dropname;
  late String picktime;
  late String droptime;
  late DateTime pickdate;
  late DateTime dropdate;
  get searchResults => null;

  @override
  void initState() {
    super.initState();
    // Initialize your variables here, for example:
    pickdate = DateTime.now();
    dropdate = DateTime.now();
    picktime = '';
    droptime = '';
  }

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

      // Assign an ID number to the document
      final int documentId = await _getNextDocumentId(collectionRef);

      // Add additional fields to the searchDetails object if needed

      // Store user's search details in Firestore with the assigned ID
      await collectionRef.doc(documentId.toString()).set({
        'pickupDate': searchDetails.pickupDate,
        'dropOffDate': searchDetails.dropOffDate,
        'pickupTime': pickupTimeStr,
        'dropOffTime': dropOffTimeStr,
        'pickupLocation': pickname, // Store pickup location as a string
        'dropOffLocation': dropname, // Store drop-off location as a string
        // Add more fields as needed...
      });

      pickdate = searchDetails.pickupDate;
      dropdate = searchDetails.dropOffDate;
      picktime = pickupTimeStr;
      droptime = dropOffTimeStr;
      _handleSearch();

      print("drop : $dropdate");
      print("droptime : $droptime");

      // Log a success message
      print('Details with ID $documentId added successfully to Firestore.');

      // Your existing code to execute the query and display search results...
    } catch (error) {
      // Print the error message for debugging
      print('Error during adding details to Firestore: $error');
    }
  }

  Future<void> _handleSearch() async {
    try {
      // Here, you can directly navigate to the RentPage with the parameters you have collected
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RentPage(
            name: widget.name,
            type: widget.vehicleType,
            imageUrl: widget.imageUrl,
            pricePerHour: widget.pricePerHour,
            pricePerDay: widget.pricePerDay,
            userName: widget.userName,
            userEmail: widget.userEmail,
            pickdate: pickdate,
            picktime: picktime,
            picklocation: pickname,
            dropdate: dropdate,
            droptime: droptime,
            droplocation: dropname,
          ),
        ),
      );
    } catch (error) {
      print('Error during search: $error');
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vehicle Rental Details',
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
                  "Vehicle Rental",
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
                      bool matchesPickupLocation =
                      pickupLocation.any((location) => location == value);
                      pickname = value;
                      // If it matches pickup location, add it to the pickupLocations list
                      if (!matchesPickupLocation) {
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
                      bool matchesDropOffLocation =
                      dropOffLocation.any((location) => location == value);
                      dropname = value;
                      // If it matches drop-off location, add it to the dropOffLocations list
                      if (!matchesDropOffLocation) {
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
                SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () {
                    _adddetails();
                    print("Date : $pickdate");
                    print("Date2 : $dropdate");
                    print("Time : $picktime");
                    print("Time2 : $droptime");
                    print("Location : $pickname");
                    print("Location2 : $dropname");
                  },
                  child: Text('Continue'),
                ),
                // Display search results
                if (searchResults != null) ...[
                  SizedBox(height: 16.0),
                  Text(
                    'Search Results:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  // You can display search results here if needed.
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Define the _selectTime method
  Future<void> _selectTime(
      BuildContext context, TimeOfDay? initialTime, Function(TimeOfDay) onTimeSelected) async {
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
}

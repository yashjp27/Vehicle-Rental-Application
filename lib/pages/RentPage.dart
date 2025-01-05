import 'package:flutter/material.dart';
import 'BookingDetails.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RentPage extends StatefulWidget {
  final String name;
  final String type;
  final String imageUrl;
  final int pricePerHour;
  final int pricePerDay;
  final String userName;
  final String userEmail;
  final DateTime pickdate;
  final String picktime;
  final String picklocation;
  final DateTime dropdate;
  final String droptime;
  final String droplocation;

  RentPage({
    required this.name,
    required this.type,
    required this.imageUrl,
    required this.pricePerHour,
    required this.pricePerDay,
    required this.userName,
    required this.userEmail,
    required this.pickdate,
    required this.picktime,
    required this.picklocation,
    required this.dropdate,
    required this.droptime,
    required this.droplocation,
  });

  @override
  _RentPageState createState() => _RentPageState();
}

class _RentPageState extends State<RentPage> {
  int selectedOption = 1;
  int mainPrice = 0;
  int totalCost = 0;
  String Insurance = 'No';
  String VehicleName ='';
  String VehicleType ='';
  String imageUrl = '';
  String Name = '';
  String Email = '';
  bool rentalCostWithInsuranceSelected = false;
  bool rentalCostWithoutInsuranceSelected = true;

  late DateTime pickupDate;
  late String pickupTime = '';
  late DateTime dropOffDate;
  late String dropOffTime = '';

  @override
  void initState() {
    super.initState();
    // Fetch the latest document from Firestore and set the values
    setState(() {
      pickupDate = widget.pickdate;
      pickupTime = widget.picktime;
      dropOffDate = widget.dropdate;
      dropOffTime = widget.droptime;
    });
    print("pickdate = $pickupDate");
    print("dropdate = $dropOffDate");
    print("picktime = $pickupTime");
    print("droptime = $dropOffTime");
    calculatePrice(); // Call the price calculation function here
    calculateCost();
    print('Totalcost : $totalCost');
  }

  Future<void> fetchLatestDocument() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('search_form')
          .orderBy('timestamp', descending: true)
          .orderBy('pickupDate', descending: true)
          .orderBy(FieldPath.documentId, descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        if (documentSnapshot.exists) {
          final data = documentSnapshot.data() as Map<String, dynamic>;

          print('Fetched data: $data');

          setState(() {
            pickupDate = widget.pickdate;
            pickupTime = widget.picktime;
            dropOffDate = widget.dropdate;
            dropOffTime = widget.droptime;
          });
          print('Pickup : $pickupDate');
          print('DropOff : $dropOffDate');
        } else {
          print('Document does not exist.');
        }
      } else {
        print('No documents found in collection');
      }
    } catch (error) {
      print('Error fetching the latest document: $error');
    }
  }

  void calculatePrice() {
    try {
      // Parse the TimeOfDay values
      final List<int> pickupTimeParts = widget.picktime.split(':').map(int.parse).toList();
      final List<int> dropOffTimeParts = widget.droptime.split(':').map(int.parse).toList();

      // Convert TimeOfDay values to DateTime objects
      final DateTime pickupDateTime = widget.pickdate
          .add(Duration(hours: pickupTimeParts[0], minutes: pickupTimeParts[1]));
      final DateTime dropOffDateTime = widget.dropdate
          .add(Duration(hours: dropOffTimeParts[0], minutes: dropOffTimeParts[1]));
      print('MainPickDatetime : $pickupDateTime');
      print('MainDropDatetime : $dropOffDateTime');

      if (pickupDateTime.isBefore(dropOffDateTime)) {
        // Calculate the time difference in hours
        final int timeDifferenceInHours = dropOffDateTime.difference(pickupDateTime).inHours;

        // Calculate the main price based on PricePerHour
        if (timeDifferenceInHours >= 24) {
          // Calculate the main price as a multiple of 24 hours
          int numberOfDays = timeDifferenceInHours ~/ 24; // Calculate the number of 24-hour blocks
          mainPrice = widget.pricePerDay * numberOfDays;

          // Calculate the additional price for any remaining hours
          int remainingHours = timeDifferenceInHours % 24; // Calculate the remaining hours
          mainPrice += widget.pricePerHour * remainingHours;
        } else {
              mainPrice = widget.pricePerHour * timeDifferenceInHours; // Price per hour
              }

              Name = widget.userName;
              Email = widget.userEmail;
              print('Type : $timeDifferenceInHours');
          print('NAME : $Name');
          print('EMAIL : $Email');
          print('Main Price: ₹$mainPrice');
        } else {
          // Handle the case where the drop-off time is before the pickup time (invalid)
          // You can show an error message or handle this case as needed.
          // For now, setting mainPrice to 0.
          mainPrice = 0;
          print('Invalid pickup and drop-off times.');
        }
      } catch (error) {
      print('Error calculating price: $error');
    }
  }


  void calculateCost() {
    if (rentalCostWithInsuranceSelected) {
      Insurance = 'Yes';
    } else {
      Insurance = 'No';
    }
    // Calculate mainPrice here based on whether insurance is selected or not
    if (rentalCostWithInsuranceSelected) {
      totalCost = mainPrice + 100;
    } else {
      totalCost = mainPrice;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rent Page'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.pink],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOption(1, 'Searched Vehicles', selectedOption == 1 ? Colors.green : Colors.green),
                  _buildOption(2, 'Vehicle Details', selectedOption == 2 ? Colors.blue : Colors.blue),
                  _buildOption(3, 'Booking Details', selectedOption == 3 ? Colors.black : Colors.black),
                  _buildOption(4, 'Payment', selectedOption == 4 ? Colors.black : Colors.black),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Container(
                    width: 350,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.network(
                        widget.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: ${widget.name}',
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                      Text(
                        'Type: ${widget.type}',
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                      Text(
                        'Price Per Hour: ₹${widget.pricePerHour}',
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                      Text(
                        'Price Per Day: ₹${widget.pricePerDay}',
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              _buildOptionWithCheckbox(
                'Rental Cost with Insurance',
                '₹${mainPrice + 100}',
                rentalCostWithInsuranceSelected,
              ),
              _buildOptionWithCheckbox(
                'Rental Cost without Insurance',
                '₹${mainPrice}',
                rentalCostWithoutInsuranceSelected,
              ),
              SizedBox(height: 30.0),
              // Increase the size of the "Continue" button
              _buildContinueButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(int number, String title, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = number;
        });
        if (number == 1) {
          // Navigate to the previous page
          Navigator.pop(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: color,
          border: Border.all(
            color: color,
            width: 2.0,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Row(
          children: [
            Container(
              width: 30.0,
              height: 30.0,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  number.toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.0),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildOptionWithCheckbox(String title, String price, bool isChecked) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (title == 'Rental Cost with Insurance') {
            rentalCostWithInsuranceSelected = !isChecked;
            rentalCostWithoutInsuranceSelected = false;
          } else if (title == 'Rental Cost without Insurance') {
            rentalCostWithoutInsuranceSelected = !isChecked;
            rentalCostWithInsuranceSelected = false;
          }
          calculateCost();
        });
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.transparent,
              border: Border.all(
                color: Colors.transparent,
                width: 2.0,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          if (title == 'Rental Cost with Insurance') {
                            rentalCostWithInsuranceSelected = value ?? false;
                            rentalCostWithoutInsuranceSelected = false;
                          } else if (title == 'Rental Cost without Insurance') {
                            rentalCostWithoutInsuranceSelected = value ?? false;
                            rentalCostWithInsuranceSelected = false;
                          }
                          calculateCost();
                        });
                      },
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
                Text(
                  price,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return ElevatedButton(
      onPressed: () {
        // Navigate to the BookingDetails.dart screen and pass the vehicle type and name
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingDetails(
              onVehicleDetailsPressed: () {
                Navigator.pop(context); // Navigate to the previous page
              },
              onSearchedVehiclesPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/')); // Navigate to the previous page of the previous page
              },
              VehicleName: widget.name,
              VehicleType: widget.type,
              totalCost : totalCost,
              Insurance : Insurance,
              imageUrl : widget.imageUrl,
              userName : widget.userName,
              userEmail : widget.userEmail,
              pickdate: widget.pickdate,
              picktime: widget.picktime,
              picklocation: widget.picklocation,
              dropdate: widget.dropdate,
              droptime: widget.droptime,
              droplocation: widget.droplocation,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Increase padding to increase button size
        child: Text(
          'Continue',
          style: TextStyle(
            fontSize: 20.0, // Increase font size
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'user_info_input.dart';

class BookingDetails extends StatefulWidget {
  final VoidCallback onVehicleDetailsPressed;
  final VoidCallback onSearchedVehiclesPressed;
  final int totalCost;
  final String VehicleName;
  final String VehicleType;
  final String Insurance;
  final String imageUrl;
  final String userName;
  final String userEmail;
  final DateTime pickdate;
  final String picktime;
  final String picklocation;
  final DateTime dropdate;
  final String droptime;
  final String droplocation;

  BookingDetails({
    required this.onVehicleDetailsPressed,
    required this.onSearchedVehiclesPressed,
    required this.totalCost,
    required this.VehicleName,
    required this.VehicleType,
    required this.Insurance,
    required this.imageUrl,
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
  _BookingDetailsState createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  late Timestamp pickupDateTimestamp = Timestamp.now();
  late String pickupTime = '';
  late String pickupLocation = '';
  late Timestamp dropOffDateTimestamp = Timestamp.now();
  late String dropOffTime = '';
  late String dropOffLocation = '';

  @override
  void initState() {
    super.initState();
    fetchLatestDocument();
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
        final data = documentSnapshot.data() as Map<String, dynamic>;

        setState(() {
          pickupDateTimestamp = data['pickupDate'];
          pickupTime = data['pickupTime'];
          pickupLocation = data['pickupLocation'];
          dropOffDateTimestamp = data['dropOffDate'];
          dropOffTime = data['dropOffTime'];
          dropOffLocation = data['dropOffLocation'];
        });
      } else {
        print('No documents found in collection');
      }
    } catch (error) {
      print('Error fetching latest document: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
      ),
      body: SingleChildScrollView(
        child: Container(
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
                    _buildOption(1, 'Searched Vehicles', Colors.green),
                    _buildOption(2, 'Vehicle Details', Colors.green),
                    _buildOption(3, 'Booking Details', Colors.blue),
                    _buildOption(4, 'Payment', Colors.black),
                  ],
                ),
                SizedBox(height: 20.0),
                _buildTicket(
                  "Pickup Details",
                  widget.pickdate,
                  widget.picktime,
                  widget.picklocation,
                  "Drop-off Details",
                  widget.dropdate,
                  widget.droptime,
                  widget.droplocation,
                  widget.VehicleName,
                  widget.VehicleType,
                  widget.totalCost,
                  widget.Insurance,
                ),
                UserInfoInput(
                  defaultEmail: widget.userEmail,
                  VehicleName : widget.VehicleName,
                  VehicleType : widget.VehicleType,
                  totalCost : widget.totalCost,
                  Insurance : widget.Insurance,
                  imageUrl : widget.imageUrl,
                  pickupDateTimestamp : widget.dropdate,
                  pickupTime : widget.picktime,
                  pickupLocation : widget.picklocation,
                  dropOffDateTimestamp : widget.dropdate,
                  dropOffTime: widget.droptime,
                  dropOffLocation: widget.droplocation,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOption(int number, String title, Color color) {
    return GestureDetector(
      onTap: () {
        if (number == 1) {
          widget.onSearchedVehiclesPressed();
        } else if (number == 2) {
          widget.onVehicleDetailsPressed();
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

  Widget _buildTicket(
      String title1,
      DateTime dateTimestamp1,
      String time1,
      String location1,
      String title2,
      DateTime dateTimestamp2,
      String time2,
      String location2,
      String vehicleName,
      String vehicleType,
      int totalCost,
      String insurance,
      ) {
    final formattedDate1 = DateFormat.yMMMMd().format(dateTimestamp1);
    final formattedDate2 = DateFormat.yMMMMd().format(dateTimestamp2);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 300.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10.0),
            Center(
              child: Text(
                'Your Trip Details',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                widget.imageUrl,
                width: 300,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20.0),
            _buildDetail("Vehicle Name :", vehicleName, Colors.blue, Colors.pink),
            _buildDetail("Vehicle Type :", vehicleType, Colors.blue, Colors.pink),
            _buildDetail("Total Cost :", "₹$totalCost", Colors.blue, Colors.pink),
            _buildDetail("Insurance :", insurance, Colors.blue, Colors.pink),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title1,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      "Date: $formattedDate1",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      "Time: $time1 IST",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      "Location: $location1, Mumbai",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title2,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      "Date: $formattedDate2",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      "Time: $time2 IST",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      "Location: $location2, Mumbai",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(String label, String value, Color labelColor, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 150.0,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 20.0,
              color: labelColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(width: 5.0),
        Text(
          value,
          style: TextStyle(
            fontSize: 20.0,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

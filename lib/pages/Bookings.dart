import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class BookingsPage extends StatefulWidget {
  final String userName;
  final String userEmail;

  BookingsPage({
    required this.userName,
    required this.userEmail,
  });

  @override
  _BookingsPageState createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  // Store the selected booking data
  Map<String, dynamic>? selectedBookingData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings'),
      ),
      backgroundColor: Colors.transparent, // Set the background to transparent
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black, Colors.pink], // Change colors here
          ),
        ),
        child: Column(
          children: [
            // Add the heading at the top center
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: _buildGlowingText(
                  'Your Bookings at Vehicle Rental',
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                  colors: [Colors.white, Colors.yellow],
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('bookings')
                    .where('Email Id', isEqualTo: widget.userEmail)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (!snapshot.hasData ||
                      snapshot.data?.docs.isEmpty == true) {
                    return Center(
                      child: Text('No bookings found for ${widget.userEmail}'),
                    );
                  }

                  var bookingDocs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: bookingDocs.length,
                    itemBuilder: (context, index) {
                      var bookingData =
                      bookingDocs[index].data() as Map<String, dynamic>;

                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          height: 200, // Set the height here
                          child: Container(
                            height: 200, // Set the height here
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.blue,
                                  Colors.green
                                ], // Blue-green gradient
                              ),
                              border: Border.all(color: Colors.black),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                // Show the pop-up with booking details
                                _showBookingDetailsPopup(context, bookingData);
                              },
                              child: TicketWidget(
                                imageUrl: bookingData['imageUrl'],
                                vehicleName: bookingData['VehicleName'],
                                vehicleType: bookingData['VehicleType'],
                                pickupLocation: bookingData['pickupLocation'],
                                dropOffLocation:
                                bookingData['dropOffLocation'],
                                totalCost: bookingData['totalCost'],
                                paymentMethod: bookingData['Payment method'],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _showBookingDetailsPopup(
      BuildContext context, Map<String, dynamic> bookingData) {
    DateTime? bookingTimestamp = bookingData['timestamp']?.toDate();
    DateTime? pickdate = bookingData['pickupDate']?.toDate();
    DateTime? dropdate = bookingData['pickupDate']?.toDate();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Booking Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailItem('Card Holder Name', bookingData['Card Holder Name']),
                _buildDetailItem('Card number', bookingData['Card number']),
                _buildDetailItem('Country', bookingData['Country']),
                _buildDetailItem('Email Id', bookingData['Email Id']),
                _buildDetailItem('Insurance', bookingData['Insurance']),
                _buildDetailItem('Payment method', bookingData['Payment method']),
                _buildDetailItem('Status', bookingData['Status']),
                _buildDetailItem('Vehicle Name', bookingData['VehicleName']),
                _buildDetailItem('Vehicle Type', bookingData['VehicleType']),
                _buildDetailItem('Aadhar Id', bookingData['aadharId'] ?? 'N/A'), // Handle null here
                _buildDetailItem('Age', bookingData['age'].toString()),
                _buildDetailItem('DropOff Date', dropdate != null ? DateFormat.yMMMd().format(dropdate) : 'N/A'),
                _buildDetailItem('DropOff Location', '${bookingData['dropOffLocation']}, Mumbai'),
                _buildDetailItem('DropOff Time', '${bookingData['dropOffTime']} IST'),
                _buildDetailItem('License Id', bookingData['licenseId'].isEmpty ? 'N/A' : bookingData['licenseId']),
                _buildDetailItem('Mobile No', bookingData['mobileNo'].toString()),
                _buildDetailItem('name', bookingData['name']),
                _buildDetailItem('Pickup Date', pickdate != null ? DateFormat.yMMMd().format(pickdate) : 'N/A'),
                _buildDetailItem('pickup Location', '${bookingData['pickupLocation']}, Mumbai'),
                _buildDetailItem('pickup Time', '${bookingData['pickupTime']} IST'),
                _buildDetailItem('Total Cost', '₹${bookingData['totalCost']}'),
                _buildDetailItem('Booking Date', bookingTimestamp != null ? DateFormat.yMMMd().format(bookingTimestamp) : 'N/A'),
                _buildDetailItem('Booking Time', bookingTimestamp != null ? DateFormat.jm().format(bookingTimestamp) : 'N/A'),

              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

// Helper function to build a detail item
  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text('$label:', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }


  Widget _buildGlowingText(String text, {
    double fontSize = 24.0,
    FontWeight fontWeight = FontWeight.normal,
    List<Color> colors = const [Colors.white, Colors.yellow],
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

class TicketWidget extends StatelessWidget {
  final String imageUrl;
  final String vehicleName;
  final String vehicleType;
  final String pickupLocation;
  final String dropOffLocation;
  final int totalCost;
  final String paymentMethod;

  TicketWidget({
    required this.imageUrl,
    required this.vehicleName,
    required this.vehicleType,
    required this.pickupLocation,
    required this.dropOffLocation,
    required this.totalCost,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue, Colors.green], // Blue-green gradient
        ),
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        children: [
          Container(
            width: 300,
            height: 200, // Set the height here
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0), // Add top padding
                  child: _buildGlowingText('Vehicle Name: $vehicleName'),
                ),
                _buildGlowingText('Vehicle Type: $vehicleType'),
                _buildGlowingText('Pickup Location: $pickupLocation'),
                _buildGlowingText('Drop-Off Location: $dropOffLocation'),
                _buildGlowingText('Total Cost: ₹$totalCost'), // Add ₹ symbol
                _buildGlowingText('Payment Method: $paymentMethod'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlowingText(
      String text, {
        double fontSize = 18.0,
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
}



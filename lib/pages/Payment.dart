import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vehicle/pages/IntroPage.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Payment extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String VehicleName;
  final String VehicleType;
  final int totalCost;
  final String Insurance;
  final String imageUrl;
  final DateTime pickupDateTimestamp;
  final String pickupTime;
  final String pickupLocation;
  final DateTime dropOffDateTimestamp;
  final String dropOffTime;
  final String dropOffLocation;
  final int age;
  final int mobileNo;
  final int? aadharId;
  final String licenseId;

  Payment({
    required this.userName,
    required this.userEmail,
    required this.VehicleName,
    required this.VehicleType,
    required this.totalCost,
    required this.Insurance,
    required this.imageUrl,
    required this.pickupDateTimestamp,
    required this.pickupTime,
    required this.pickupLocation,
    required this.dropOffDateTimestamp,
    required this.dropOffTime,
    required this.dropOffLocation,
    required this.age,
    required this.mobileNo,
    required this.aadharId,
    required this.licenseId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.pink],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
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
                          _buildOption(3, 'Booking Details', Colors.green),
                          _buildOption(4, 'Payment', Colors.blue),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      _buildTicket(
                        VehicleName,
                        VehicleType,
                        totalCost,
                        Insurance,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _buildPayNowButton(context),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(int number, String title, Color color) {
    return GestureDetector(
      onTap: () {},
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
      String vehicleName,
      String vehicleType,
      int totalCost,
      String insurance,
      ) {
    return Container(
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
              'Order Summary',
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
              imageUrl,
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
        ],
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

  Widget _buildPayNowButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 20.0), // Add padding to push the button up
      child: TextButton( // Use TextButton to create a text-only button
        onPressed:(){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return PaymentPopup(
                userName: userName ?? '',
                userEmail: userEmail,
                VehicleName: VehicleName,
                VehicleType: VehicleType,
                totalCost: totalCost,
                Insurance: Insurance,
                imageUrl: imageUrl,
                pickupDateTimestamp : pickupDateTimestamp,
                pickupTime : pickupTime,
                pickupLocation : pickupLocation,
                dropOffDateTimestamp : dropOffDateTimestamp,
                dropOffTime: dropOffTime,
                dropOffLocation: dropOffLocation,
                age: age ?? 20,
                mobileNo: mobileNo ?? 7715083357,
                aadharId: aadharId,
                licenseId: licenseId?? '',
              ); // Show the custom payment popup
            },
          );
        },
        style: TextButton.styleFrom(
          primary: Colors.black, // Text color
          textStyle: TextStyle(fontSize: 20), // Text style
        ),
        child: Text('PAY NOW'),
      ),
    );
  }
}


class PaymentPopup extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String VehicleName;
  final String VehicleType;
  final int totalCost;
  final String Insurance;
  final String imageUrl;
  final DateTime pickupDateTimestamp;
  final String pickupTime;
  final String pickupLocation;
  final DateTime dropOffDateTimestamp;
  final String dropOffTime;
  final String dropOffLocation;
  final int age;
  final int mobileNo;
  final int? aadharId;
  final String licenseId;

  PaymentPopup({
    required this.userName,
    required this.userEmail,
    required this.VehicleName,
    required this.VehicleType,
    required this.totalCost,
    required this.Insurance,
    required this.imageUrl,
    required this.pickupDateTimestamp,
    required this.pickupTime,
    required this.pickupLocation,
    required this.dropOffDateTimestamp,
    required this.dropOffTime,
    required this.dropOffLocation,
    required this.age,
    required this.mobileNo,
    required this.aadharId,
    required this.licenseId,
  });

  @override
  _PaymentPopupState createState() => _PaymentPopupState();
}

class _PaymentPopupState extends State<PaymentPopup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _cardNumberError;
  String? _cvvError;

  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _cvvController = TextEditingController();
  TextEditingController _expiryDateController = TextEditingController();
  TextEditingController _cardHolderNameController = TextEditingController();
  List<String> _countries = [
  'India',
  'France',
  'USA',
  'Canada',
  'Australia',
  'United Kingdom',
  'Germany',
  'Japan',
  'Brazil',
  'Mexico',
  'China',
  'South Korea',
  'Russia',
  'South Africa',
  'Argentina',
  'Italy',
  'Spain',
  'Netherlands',
  'Belgium',
  'Sweden',
  'Norway',
  'Denmark',
  'Finland',
  'Switzerland',
  'Austria',
  'Greece',
  'Portugal',
  'Turkey',
  'Egypt',
  'Saudi Arabia',
  'United Arab Emirates',
  'Qatar',
  'Kuwait',
  'Singapore',
  'Malaysia',
  'Thailand',
  'Indonesia',
  'Vietnam',
  'Philippines',
  'New Zealand',
  'Israel',
  'Ireland',
  'Poland',
  'Hungary',
  'Czech Republic',
  'Romania',
  'Ukraine',
  'Chile',
  ];
  String _selectedCountry = 'India'; // Default selected country
  bool isLoading = false;
  bool paymentSuccess = false;

  void simulatePayment() {
    // Simulate payment processing for 5 seconds
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        isLoading = false;
        paymentSuccess = true;
      });
    });
  }

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
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      content: SizedBox(
        width: 850,
        height: 700,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  color: Colors.blue,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Vehicle Rental',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildVehicleInfo(),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCardInfo(), // Add Expiry Date field here
                    SizedBox(height: 20),
                    _buildButtons(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleInfo() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    widget.imageUrl,
                    width: 300,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20), // Add spacing below the image
                Text(
                  widget.VehicleName,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.VehicleType,
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10), // Add spacing between vehicle details
            Text(
              '₹${widget.totalCost} (Inclusive of all taxes)',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 220),
            Text(
              '© 2023 VehicleRental | Powered by VR',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildCardInfo() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey, // Set the key of the Form
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Card Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _cardNumberController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(12), // Limit to 12 digits
                    ],
                    onChanged: (value) {
                      setState(() {
                        _cardNumberError =
                        value.length == 12 ? null : 'Enter the correct Card Number';
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Card Number',
                      suffixIcon: Icon(Icons.credit_card),
                      errorText: _cardNumberError,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the card number';
                      }
                      // You can add additional validation logic here if needed
                      return null; // Return null to indicate no validation errors
                    },
                  ),
                ),
                SizedBox(width: 20),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _cvvController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3), // Limit to 3 digits
                    ],
                    onChanged: (value) {
                      setState(() {
                        _cvvError = value.length == 3 ? null : 'Enter a valid 3-digit CVV';
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      errorText: _cvvError,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the CVV';
                      }
                      // You can add additional validation logic here if needed
                      return null; // Return null to indicate no validation errors
                    },
                  ),
                ),
                SizedBox(width: 20),
              ],
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _expiryDateController,
              keyboardType: TextInputType.text, // Allow text input for MM/YYYY
              onChanged: (value) {
                setState(() {
                  _formatExpiryDate(value);
                });
              },
              decoration: InputDecoration(
                labelText: 'Expiry Date (MM/YYYY)',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the expiry date';
                }
                // You can add additional validation logic here if needed
                return null; // Return null to indicate no validation errors
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _cardHolderNameController,
              decoration: InputDecoration(
                labelText: 'Cardholder Name',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the cardholder name';
                }
                // You can add additional validation logic here if needed
                return null; // Return null to indicate no validation errors
              },
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedCountry,
              onChanged: (value) {
                setState(() {
                  _selectedCountry = value!;
                });
              },
              items: _countries.map((country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Country or Region',
              ),
              validator: (value) {
                if (value == null) {
                  return 'Please select a country';
                }
                // You can add additional validation logic here if needed
                return null; // Return null to indicate no validation errors
              },
            ),
          ],
        ),
      ),
    );
  }

  void _formatExpiryDate(String value) {
    if (value.length == 1 && value != '0' && value != '1') {
      _expiryDateController.text = '0$value/';
      _expiryDateController.selection = TextSelection.fromPosition(
          TextPosition(offset: _expiryDateController.text.length));
    } else if (value.length == 2 && !value.contains('/')) {
      _expiryDateController.text = '$value/';
      _expiryDateController.selection = TextSelection.fromPosition(
          TextPosition(offset: _expiryDateController.text.length));
    }
  }



  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.pinkAccent,
            borderRadius: BorderRadius.circular(5),
          ),
          child: isLoading
              ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
              : paymentSuccess
              ? Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 40,
          )
              : TextButton(
            onPressed: () async{
              if (isLoading) {
                return; // Prevent multiple payment attempts while loading
              }
              // Validate all form fields
              if (_formKey.currentState!.validate()) {
                setState(() {
                  isLoading = true;
                });
                // Create a Firestore reference to the 'bookings' collection
                CollectionReference<Map<String, dynamic>> bookingsCollection =
                FirebaseFirestore.instance.collection('bookings');

                // Generate the next document ID
                int nextDocumentId = await _getNextDocumentId(bookingsCollection);

                // Add the data to Firestore with the autogenerated ID
                await bookingsCollection.doc(nextDocumentId.toString()).set({
                  'Email Id': widget.userEmail,
                  'VehicleName': widget.VehicleName,
                  'VehicleType': widget.VehicleType,
                  'totalCost': widget.totalCost,
                  'Insurance': widget.Insurance,
                  'imageUrl': widget.imageUrl,
                  'pickupDate': widget.pickupDateTimestamp,
                  'pickupTime': widget.pickupTime,
                  'pickupLocation': widget.pickupLocation,
                  'dropOffDate': widget.dropOffDateTimestamp,
                  'dropOffTime': widget.dropOffTime,
                  'dropOffLocation': widget.dropOffLocation,
                  'name': widget.userName,
                  'age': widget.age,
                  'mobileNo': widget.mobileNo,
                  'aadharId': widget.aadharId,
                  'licenseId': widget.licenseId,
                  'Status': 'Yes',
                  'Payment method' : 'Credit Card',
                  'Card number': '${_cardNumberController.text}',
                  'Card Holder Name': '${_cardHolderNameController.text}',
                  'Country': '$_selectedCountry',
                  'timestamp': FieldValue.serverTimestamp(),
                });

                print('Booking added to Firestore.');

                // Print card details
                printCardDetails();

                // Simulate payment processing for 5 seconds
                Future.delayed(Duration(seconds: 5), () {
                  // After 5 seconds, set payment success and navigate to the success page
                  setState(() {
                    paymentSuccess = true;
                  });

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Booking Successful'),
                        content: Row(
                          children: [
                            Text('Your Booking at Vehicle Rental is successful '),
                            Text('😊', style: TextStyle(fontSize: 24),), // Smiling face emoji
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => IntroPage(
                                    userName: widget.userName,
                                    userEmail: widget.userEmail,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                });
              } else {
                // Show a snackbar indicating validation errors
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please correct the errors in the form'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text(
              paymentSuccess ? 'Payment Successful' : 'Pay',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(width: 20),
        TextButton(
          onPressed: () {
            print('Card Number: ${_cardNumberController.text}');
            print('CVV: ${_cvvController.text}');
            print('Expiry Date: ${_expiryDateController.text}');
            print('Cardholder Name: ${_cardHolderNameController.text}');
            print('Country or Region: $_selectedCountry');
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }

  void printCardDetails() {
    print('Card Number: ${_cardNumberController.text}');
    print('CVV: ${_cvvController.text}');
    print('Expiry Date: ${_expiryDateController.text}');
    print('Cardholder Name: ${_cardHolderNameController.text}');
    print('Country or Region: $_selectedCountry');
  }
}




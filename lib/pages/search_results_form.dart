import 'package:flutter/material.dart';
import 'RentPage.dart';
import 'VehicleSearchPage.dart';

class SearchResultsForm extends StatelessWidget {
  final List<Map<String, dynamic>> searchResults;
  final SearchDetails searchDetails;
  final String userName;
  final String userEmail;
  final DateTime pickdate;
  final String picktime;
  final String picklocation;
  final DateTime dropdate;
  final String droptime;
  final String droplocation;

  SearchResultsForm(this.searchResults, this.searchDetails,
       this.userName, this.userEmail,
      this.pickdate, this.picktime, this.picklocation,
      this.dropdate, this.droptime, this.droplocation,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.pink], // Adjust the gradient colors
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOption(1, 'Searched Vehicles', Colors.blue),
                  _buildOption(2, 'Vehicle Details', Colors.black),
                  _buildOption(3, 'Booking Details', Colors.black),
                  _buildOption(4, 'Payment', Colors.black),
                ],
              ),
              SizedBox(height: 20.0),
              Expanded(
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final result = searchResults[index];
                    final imageUrl = result['imageUrl'] ?? '';
                    final name = result['name'] ?? 'N/A';
                    final type = result['type'] ?? 'N/A';
                    final pricePerHour = result['pricePerHour'] ?? 'N/A';
                    final pricePerDay = result['pricePerDay'] ?? 'N/A';

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0), // Adjust gap here
                      child: Row(
                        children: [
                          if (imageUrl.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0), // Rounded corners
                              child: Container(
                                width: 350, // Adjust image width
                                height: 200, // Adjust image height
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          SizedBox(width: 10), // Gap between image and details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 18, // Adjust the font size as needed
                                    color: Colors.black, // Text color
                                  ),
                                ),
                                Text(
                                  'Type: $type',
                                  style: TextStyle(
                                    fontSize: 16, // Adjust the font size as needed
                                    color: Colors.black, // Text color
                                  ),
                                ),
                                Text(
                                  'Price per Hour: $pricePerHour',
                                  style: TextStyle(
                                    fontSize: 16, // Adjust the font size as needed
                                    color: Colors.black, // Text color
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Price per Day: $pricePerDay',
                                      style: TextStyle(
                                        fontSize: 16, // Adjust the font size as needed
                                        color: Colors.black, // Text color
                                      ),
                                    ),
                                    SizedBox(height: 10), // Gap between text and button
                                    InkWell(
                                      onTap: () {
                                        _showVehicleDetails(context, name, type, imageUrl, pricePerHour, pricePerDay); // Show details on button click
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.blue, // Button background color
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.blue.withOpacity(0.5),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                            vertical: 4.0,
                                          ),
                                          child: Text(
                                            'Rent Now',
                                            style: TextStyle(
                                              color: Colors.white, // Text color
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVehicleDetails(BuildContext context, String name, String type, String imageUrl, int pricePerHour, int pricePerDay) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RentPage(
          name: name,
          type: type,
          imageUrl: imageUrl,
          pricePerHour: pricePerHour,
          pricePerDay: pricePerDay,
          userName : userName,
          userEmail : userEmail,
          pickdate: pickdate,
          picktime: picktime,
          picklocation: picklocation,
          dropdate: dropdate,
          droptime: droptime,
          droplocation: droplocation,
        ),
      ),
    );
  }

  Widget _buildOption(int number, String title, Color color) {
    return GestureDetector(
      onTap: () {
        // Handle option clicks here
        print ('userName : $userName');
        print ('userEmail : $userEmail');
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
}

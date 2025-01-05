import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vehicle/pages/AutoRecommendPage.dart';
import 'package:vehicle/pages/Bookings.dart';
import 'package:vehicle/pages/Bookingsadmin.dart';
import 'package:vehicle/pages/TrendingVehiclesPage.dart';
import 'package:vehicle/pages/VehicleSearchPageRent.dart';
import 'package:vehicle/services/authFunctions.dart';
import 'package:vehicle/main.dart';
import 'Filters.dart';
import 'UserInfoPage.dart';
import 'VehicleSearchPage.dart';
import 'AboutUs.dart';
import 'ContactUs.dart';
import 'ContactDetails.dart';
import 'VehicleDetailsPage.dart';

class IntroPage extends StatefulWidget {
  final String userName;
  final String userEmail;

  IntroPage({
    required this.userName,
    required this.userEmail,
  });

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  static const Color grad1 = Color(0xFF03a9f4);
  static const Color grad2 = Color(0xFFf441a5);
  static const Color grad3 = Color(0xFFffeb3b);
  static const Color grad4 = Color(0xFF03a9f4);
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();
  List<String> suggestions = [];
  String vehiclesearch = '';

  final CollectionReference vehiclesCollection =
  FirebaseFirestore.instance.collection('vehicles');

  List<Widget> vehicleList = [];

  @override
  void initState() {
    super.initState();
    // Fetch vehicles from Firestore when the widget initializes
    fetchVehicles();
  }

  void updateSearchControllerText(String option) {
    setState(() {
      searchController.text = option;
    });
  }

  void fetchVehicles() async {
    // Query the Firestore collection for vehicles
    QuerySnapshot querySnapshot = await vehiclesCollection.get();

    // Process the query snapshot to create a list of vehicle widgets
    List<Widget> vehicles = querySnapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      return Stack(
        children: [
          Container(
            height: 230,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        title: _buildGlowingText(
                          data['name'] ?? '',
                          fontSize: 30,
                          fontWeight: FontWeight.normal, // You can adjust the font weight as needed
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
    }).toList();

    // Update the state with the fetched vehicle list
    setState(() {
      vehicleList = vehicles;
    });
  }

  // Function to handle log out
  void _handleLogOut(BuildContext context) async {
    await AuthServices.signoutUser(context);

    // After logging out, navigate to the home screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Rental'),
        actions: [
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(widget.userName),
              accountEmail: Text(widget.userEmail),
              currentAccountPicture: widget.userEmail == "nadarnikson@gmail.com"
                  ? CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage('https://firebasestorage.googleapis.com/v0/b/vehicle-rental-2.appspot.com/o/vehicle_images%2Fnikson.jpg?alt=media&token=e63675b8-9d71-43a3-b6a4-9cb85e9ee3c6&_gl=1*19ispom*_ga*MjExODc1MTExNC4xNjk3MjAwODc5*_ga_CW55HF8NVT*MTY5NzI5MzI4MS4xMy4xLjE2OTcyOTM4NDQuNDkuMC4w'),
              )
                  : CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person),
              ),
            ),
            ListTile(
              title: Text('User Information'),
              leading: Icon(Icons.person),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        UserInfoPage(
                          email : widget.userEmail,
                        ),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Vehicles Search'),
              leading: Icon(Icons.search),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        VehicleSearchPage(
                          userName: widget.userName,
                          userEmail: widget.userEmail,
                        ),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Search Filters'),
              leading: Icon(Icons.filter_alt_sharp),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FilterPage(
                      userName: widget.userName,
                      userEmail: widget.userEmail,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Trending Vehicles'),
              leading: Icon(Icons.trending_up),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        TrendingVehiclesPage(
                          userName: widget.userName,
                          userEmail: widget.userEmail,
                        ),
                  ),
                );
              },
            ),
            if(widget.userEmail != 'nikson@gmail.com')
            ListTile(
              title: Text('Bookings'),
              leading: Icon(Icons.book),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        BookingsPage(
                          userName: widget.userName,
                          userEmail: widget.userEmail,
                        ),
                  ),
                );
              },
            ),
            if(widget.userEmail == 'nikson@gmail.com')
              ListTile(
                title: Text('Bookings Dashboard'),
                leading: Icon(Icons.book),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          Bookingsadmin(
                            userName: widget.userName,
                            userEmail: widget.userEmail,
                          ),
                    ),
                  );
                },
              ),
            Divider(),
            ListTile(
              title: Text('VR Recommender'),
              leading: Icon(Icons.recommend),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        AutoRecommendVideoPage(
                          userName: widget.userName,
                          userEmail: widget.userEmail,
                        ),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('About Us'),
              leading: Icon(Icons.info),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AboutUsPage(),
                  ),
                );
              },
            ),
            if (widget.userEmail != 'nikson@gmail.com')
            ListTile(
              title: Text('Contact Us'),
              leading: Icon(Icons.contact_mail),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ContactUsPage(),
                  ),
                );
              },
            ),
            if (widget.userEmail == 'nikson@gmail.com')
              ListTile(
                title: Text('Contact Mail'),
                leading: Icon(Icons.contact_mail),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ContactsDetailsPage(),
                    ),
                  );
                },
              ),
            Divider(),
            ListTile(
              title: Text('Log Out'),
              leading: Icon(Icons.logout),
              onTap: () {
                _handleLogOut(context);
              },
            ),
          ],
        ),
      ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF03a9f4), Color(0xFFf441a5)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildGlowingText(
                  'Our Fleet', // Use the _buildGlowingText widget for the 'Our Fleet' text
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pinkAccent,
                        blurRadius: 10.0,
                        spreadRadius: 5.0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'Search Vehicle',
                            hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            shadows: <Shadow>[
                              Shadow(
                                blurRadius: 5.0,
                                color: Colors.yellow,
                              ),
                            ],
                          ),
                          onChanged: (query) {
                            // Implement your search logic here
                            // Update the visibility of the "Search Filters" option or suggestions.
                            fetchVehicles(); // Call the fetchVehicles method to update the list
                          },
                          onSubmitted: (query) {
                            setState(() {
                              vehiclesearch = query;
                              print('Vehicle : $vehiclesearch');
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      VehicleDetailsPage(vehicleName: vehiclesearch,
                                          userName: widget.userName,
                                          userEmail: widget.userEmail),
                                ),
                              );
                            });
                            // You can add additional logic here if needed, such as executing the search.
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: searchController.text.isEmpty
                      ? null // If the search query is empty, don't listen to the stream
                      : vehiclesCollection.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (searchController.text.isEmpty) {
                      // The search query is empty, so you can display the list of vehicles.
                      return ListView.builder(
                        itemCount: vehicleList.length,
                        itemBuilder: (context, index) {
                          return vehicleList[index];
                        },
                      );
                    }

                    // Process and display the filtered data
                    return ListView.builder(
                      itemCount: snapshot.data?.docs.length ?? 0,
                      itemBuilder: (context, index) {
                        var data = snapshot.data?.docs[index].data() as Map<String, dynamic>;

                        // Check if the 'name' property is not null before using toLowerCase
                        if (data['name'] != null &&
                            data['name'].toLowerCase().contains(searchController.text.toLowerCase())) {
                          return ListTile(
                            title: Text(data['name'] ?? ''),
                            // Display other details here
                            onTap: () {
                              updateSearchControllerText(data['name'] ?? '');
                            },
                          );
                        }

                        return Container(); // Return an empty container if the name is null or doesn't match the search.
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

  Widget _buildGlowingText(
      String text, {
        double fontSize = 24.0,
        FontWeight fontWeight = FontWeight.normal,
      }) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          shadows: [
            Shadow(
              color: Colors.black,
              offset: Offset(0, 0),
              blurRadius: 10.0,
            ),
            Shadow(
              color: Colors.yellow, // Yellow color for the glowing effect
              offset: Offset(0, 0),
              blurRadius: 10.0,
            ),
          ],
        ),
        children: [
          TextSpan(
            text: text,
            style: TextStyle(
              color: Colors.white, // White color for the text
            ),
          ),
        ],
      ),
    );
  }
}

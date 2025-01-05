import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'VRRecommender4Page.dart';

class VRRecommender3Page extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String selectedVehicle;
  final String pickupLocation;
  final String dropLocation;

  VRRecommender3Page({
    required this.userName,
    required this.userEmail,
    required this.selectedVehicle,
    required this.pickupLocation,
    required this.dropLocation,
  });

  @override
  _VRRecommender3PageState createState() => _VRRecommender3PageState();
}

class _VRRecommender3PageState extends State<VRRecommender3Page> {
  late VideoPlayerController _controller;
  bool _isVideoPlaying = false;
  String preference = '';

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/animation_4.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(false);
        _controller.play().then((_) {
          // Do nothing when the video playback starts
        });
      });
  }

  void setPreference(String value) {
    setState(() {
      preference = value;
    });
  }

  Future<void> fetchVehicleName() async {
    List<String> matchingVehicleNames = [];

    if (preference.isNotEmpty) {
      String pickupLocation = widget.pickupLocation; // The pickup location you want to check
      String dropLocation = widget.dropLocation; // The drop-off location you want to check

      QuerySnapshot typeQuery = await FirebaseFirestore.instance
          .collection('vehicles')
          .where('type', isEqualTo: widget.selectedVehicle)
          .get();
      print("Type Query Results: ${typeQuery.docs.map((doc) => doc['name'])}");

      QuerySnapshot pickupQuery = await FirebaseFirestore.instance
          .collection('vehicles')
          .where('pickupLocation', arrayContains: pickupLocation)
          .get();
      print("Pickup Query Results: ${pickupQuery.docs.map((doc) => doc['name'])}");

      QuerySnapshot dropOffQuery = await FirebaseFirestore.instance
          .collection('vehicles')
          .where('dropOffLocation', arrayContains: dropLocation)
          .get();
      print("DropOff Query Results: ${dropOffQuery.docs.map((doc) => doc['name'])}");

      QuerySnapshot preferenceQuery = await FirebaseFirestore.instance
          .collection('vehicles')
          .where('Preference', isEqualTo: preference)
          .get();
      print("Preference Query Results: ${preferenceQuery.docs.map((doc) => doc['name'])}");

      // Extract the document IDs from each query result
      Set<String> typeDocs = Set.from(typeQuery.docs.map((doc) => doc.id));
      Set<String> pickupDocs = Set.from(pickupQuery.docs.map((doc) => doc.id));
      Set<String> dropOffDocs = Set.from(dropOffQuery.docs.map((doc) => doc.id));
      Set<String> preferenceDocs = Set.from(preferenceQuery.docs.map((doc) => doc.id));

      // Find the common document IDs
      Set<String> commonDocs = typeDocs.intersection(pickupDocs).intersection(dropOffDocs).intersection(preferenceDocs);

      if (commonDocs.isNotEmpty) {
        // Fetch the common documents and get their 'name' values
        QuerySnapshot commonQuery = await FirebaseFirestore.instance
            .collection('vehicles')
            .where(FieldPath.documentId, whereIn: commonDocs.toList())
            .get();

        for (var doc in commonQuery.docs) {
          matchingVehicleNames.add(doc['name']);
        }
        print("Common Query Results: ${matchingVehicleNames}");
      } else {
        showErrorMessage(context, 'No matching vehicle found.');
      }

      if (matchingVehicleNames.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VRRecommender4Page(
              userName: widget.userName,
              userEmail: widget.userEmail,
              matchingVehicleNames: matchingVehicleNames,
              pickupLocation : widget.pickupLocation,
              dropOffLocation : widget.dropLocation,
            ),
          ),
        );
      }
    } else {
      showErrorMessage(context, 'Please select either Luxury or Cheap');
    }
  }




  void showErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VR Recommender'),
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
          FutureBuilder(
            future: _controller.initialize(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                _isVideoPlaying = true;
                return Positioned(
                  left: 30,
                  right: 0,
                  bottom: 130,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 240,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              DropdownButton<String>(
                                hint: Text('Preferences'), // Set the hint text
                                value: preference.isEmpty ? null : preference, // Ensure value is null when preference is empty
                                onChanged: (value) {
                                  setPreference(value!);
                                },
                                items: <String>['Luxury', 'Cheap'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_forward,
                                  size: 30,
                                  color: Colors.pink, // Set the arrow color to pink
                                ),
                                onPressed: fetchVehicleName,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container(); // Placeholder when video is not ready
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}



import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'VRRecommender3Page.dart';

class VRRecommender2Page extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String selectedVehicle;
  final String pickupLocation;

  VRRecommender2Page({
    required this.userName,
    required this.userEmail,
    required this.selectedVehicle,
    required this.pickupLocation,
  });

  @override
  _VRRecommender2PageState createState() => _VRRecommender2PageState();
}

class _VRRecommender2PageState extends State<VRRecommender2Page> {
  late VideoPlayerController _controller;
  bool _isVideoPlaying = false;
  final TextEditingController _dropoffController = TextEditingController();
  String dropLocation = ''; // Variable to store user entered data

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/animation_3.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(false);
        _controller.play().then((_) {
          // Add listener to check when the video playback is completed
          _controller.addListener(() {
            if (_controller.value.position >= _controller.value.duration) {
              setState(() {
                _isVideoPlaying = true;
              });
            }
          });
        });
      });
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

  void storeDropLocation() {
    setState(() {
      dropLocation = _dropoffController.text;
      print('User entered dropLocation: $dropLocation');
    });
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
          if (_isVideoPlaying) // Only display the label box and arrow after the video is completely played
            Positioned(
              left: 30,
              right: 0,
              bottom: 130,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 240, // Set the width of the label box to 240
                    decoration: BoxDecoration(
                      color: Colors.blue, // Set the background color of the label box to blue
                      border: Border.all(
                        color: Colors.black, // Outline color
                        width: 2.0, // Specify the outline thickness
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _dropoffController,
                        decoration: InputDecoration(
                          hintText: 'Dropoff Location',
                          border: InputBorder.none, // Remove the default input border
                        ),
                        textAlign: TextAlign.center, // Center-align the text
                      ),
                    ),
                  ),
                  SizedBox(height: 10), // Create space between the label and the arrow
                  IconButton(
                    icon: Icon(
                      Icons.arrow_forward,
                      size: 50,
                      color: Colors.pink, // Set the arrow color to pink
                    ),
                    onPressed: () {
                        storeDropLocation();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VRRecommender3Page(
                                  userName: widget.userName,
                                  userEmail: widget.userEmail,
                                  selectedVehicle: widget.selectedVehicle,
                                  pickupLocation: widget.pickupLocation,
                                  dropLocation: dropLocation,
                                ),
                          ),
                        );
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _dropoffController.dispose(); // Dispose of the text controller
  }
}




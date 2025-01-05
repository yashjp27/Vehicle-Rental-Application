import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import 'VRRecommender2Page.dart';

class AutoRecommendVideoPage extends StatefulWidget {
  final String userName;
  final String userEmail;

  AutoRecommendVideoPage({
    required this.userName,
    required this.userEmail,
  });

  @override
  _AutoRecommendVideoPageState createState() => _AutoRecommendVideoPageState();
}

class _AutoRecommendVideoPageState extends State<AutoRecommendVideoPage> {
  late VideoPlayerController _controller;
  TextEditingController _pickupLocationController = TextEditingController();
  bool _isVideoPlaying = false;
  bool _showLabel = false;
  bool _showPickupLocation = false;
  String? _selectedOption;
  String _pickupLocation = ""; // Variable to store pickup location

  final List<String> _options = [
    'Car',
    'Motorbike',
    'Scooter',
    'Cycle',
    'Truck',
    'Bus',
  ];

  Widget _buildGlowingText(
      String text, {
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

  Future<void> _loadVideo(String? option) async {
    String? videoPath;

    if (option != null) {
      videoPath = 'assets/animation_2.mp4';
    }

    if (_controller != null) {
      await _controller.dispose();
    }

    if (videoPath != null) {
      _controller = VideoPlayerController.asset(videoPath);
      await _controller.initialize().then((_) {
        setState(() {});
        _controller.setLooping(false);
        _controller.play().then((_) {
          setState(() {
            _isVideoPlaying = true;
          });
        });
        _controller.addListener(() {
          if (_controller.value.position >= _controller.value.duration) {
            setState(() {
              _isVideoPlaying = false;
              _showPickupLocation = true; // Show the text box after the video is played
            });
          }
        });
      });
    } else {
      setState(() {});
    }
  }

  void _restartVideo() {
    _controller.seekTo(Duration.zero);
    _controller.play();
    setState(() {
      _isVideoPlaying = true;
      _showPickupLocation = false;
    });
  }

  void _handleKeyEvent(RawKeyEvent keyEvent) {
    if (keyEvent is RawKeyDownEvent) {
      if (keyEvent.logicalKey.keyId == LogicalKeyboardKey.enter.keyId) {
        if (_selectedOption != null) {
          String vehicle = _selectedOption!;
          print('Selected vehicle: $vehicle');
          setState(() {
            _showLabel = false;
          });
          _loadVideo('animation_2.mp4');
        } else if (_pickupLocation.isNotEmpty) {
          String picklocation = _pickupLocation;
          print('Pickup Location: $picklocation'); // Print stored pickup location
          setState(() {
            _showPickupLocation = false;
            _showLabel = true;
          });
          _loadVideo('animation_3.mp4'); // Load animation_3.mp4
        }
      }
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

  void _loadAnimation3() {
    String picklocation = _pickupLocationController.text;

    if (picklocation.isNotEmpty) {
      print('Pickup Location: $picklocation');
      print("VEHICLE : $_selectedOption");

      // Navigate to the VR page and pass the selected vehicle and pickup location
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VRRecommender2Page(
            userName : widget.userName,
            userEmail : widget.userEmail,
            selectedVehicle: _selectedOption ?? "",
            pickupLocation: picklocation,
          ),
        ),
      );
    }
    else{
      showErrorMessage(context, 'Please enter correct location');
    }
  }




  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/animation_1.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(false);
        _controller.play().then((_) {
          setState(() {
            _isVideoPlaying = true;
          });
        });
        _controller.addListener(() {
          if (_controller.value.position >= _controller.value.duration) {
            setState(() {
              _isVideoPlaying = false;
              _showLabel = true;
            });
          }
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VR Recommender'),
      ),
      backgroundColor: Colors.black,
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (keyEvent) {
          _handleKeyEvent(keyEvent);
        },
        child: Stack(
          children: [
            if (_controller.value.isInitialized)
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (!_isVideoPlaying) {
                      _restartVideo();
                    }
                  },
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
            if (_showLabel)
              Positioned(
                left: 0,
                right: 0,
                bottom: 180,
                child: Center(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Colors.pinkAccent,
                    ),
                    child: Container(
                      width: 200,
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 10),
                          DropdownButton<String>(
                            value: _selectedOption,
                            items: [
                              DropdownMenuItem<String>(
                                value: null,
                                child: Text('Select Vehicle'),
                              ),
                              for (String option in _options)
                                DropdownMenuItem<String>(
                                  value: option,
                                  child: _buildGlowingText(option),
                                ),
                            ],
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedOption = newValue;
                              });
                            },
                            underline: Container(),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            isExpanded: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            if (_showPickupLocation)
              Positioned(
                left: 30,
                right: 0,
                bottom: 120,
                child: Center(
                  child: Container(
                    width: 200,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _pickupLocationController, // Use TextEditingController
                          decoration: InputDecoration(
                            hintText: 'Pickup Location',
                            contentPadding: EdgeInsets.only(top: 20.0),
                          ),
                          onChanged: (value) {
                            // Store the entered pickup location
                            setState(() {
                              _pickupLocation = value;
                            });
                          },
                        ),
                        SizedBox(height: 10),
                          IconButton(
                            icon: Icon(Icons.arrow_forward),
                            onPressed: _loadAnimation3,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.setVolume(1.0);
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/authFunctions.dart';
import 'pages/IntroPage.dart';
import 'RegisterPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  bool login = true;
  bool showGif = false; // Control whether to show the GIF or not

  String loggedInUserName = '';
  String loggedInUserEmail = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(login ? 'Login' : 'Register'),
      ),
      body: Stack(
        children: [
          // Background Image
          Image.network(
            'https://firebasestorage.googleapis.com/v0/b/vehicle-rental-2.appspot.com/o/other%2Fback_1.jpeg?alt=media&token=e7ed5cb2-4667-4529-a206-c856e9d42118',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(14),
              color: Colors.white.withOpacity(0.7),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      key: ValueKey('email'),
                      decoration: InputDecoration(
                        hintText: 'Enter Email',
                      ),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Please Enter a valid Email';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        setState(() {
                          email = value!;
                        });
                      },
                    ),
                    TextFormField(
                      key: ValueKey('password'),
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter Password',
                      ),
                      validator: (value) {
                        if (value!.length < 6) {
                          return 'Password must be at least 6 characters long';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        setState(() {
                          password = value!;
                        });
                      },
                    ),
                    SizedBox(height: 30),
                    Container(
                      height: 55,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            User? user = await AuthServices.signinUser(
                              email,
                              password,
                              context,
                            );

                            if (user != null) {
                              setState(() {
                                loggedInUserName = user.displayName ?? '';
                                loggedInUserEmail = user.email ?? '';
                                showGif = true; // Show the GIF after login.
                              });
                              _showGifPopup(context);
                            }
                          }
                        },
                        child: Text(login ? 'Login' : 'Register'),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          login = !login;
                        });

                        if (!login) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => RegisterForm()),
                          );
                        }
                      },
                      child: Text(login
                          ? "Don't have an account? Register"
                          : "Already have an account? Login"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showGifPopup(BuildContext context) {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black, // Set the background color of the popup
            contentPadding: EdgeInsets.zero,
            content: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0), // Add left and right padding
              child: SizedBox(
                width: 900.0, // Set the width of the popup
                height: 600.0, // Set the height of the popup
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20.0), // Add top padding
                      child: _buildGlowingText(
                        'Welcome $loggedInUserName',
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        colors: [Colors.white, Colors.yellow],
                      ),
                    ),
                    SizedBox(height: 20.0), // Add spacing between text and image
                    Expanded(
                      child: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/vehicle-rental-2.appspot.com/o/gif%2Fnikson1.gif?alt=media&token=602dcfbe-b6ef-4332-a47c-8669e29ce4d7&_gl=1*1a4aszl*_ga*MzU3MjE5ODMxLjE2OTQwODQwODY.*_ga_CW55HF8NVT*MTY5NjQxMjI1OS43Mi4xLjE2OTY0MTI1NjcuMzMuMC4w',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 20.0), // Add bottom padding
                  ],
                ),
              ),
            ),
          );
        },
      );

      // Close the GIF popup after 5 seconds
      Future.delayed(Duration(seconds: 5), () {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => IntroPage(
              userName: loggedInUserName,
              userEmail: loggedInUserEmail,
            ),
          ),
        );
      });
    });
  }







  Widget _buildGlowingText(
      String text, {
        double fontSize = 24.0,
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



import 'package:flutter/material.dart';
import 'package:vehicle/pages/IntroPage.dart';
import 'services/authFunctions.dart';
import 'LoginPage.dart'; // Import your LoginPage.dart file

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String fullname = '';
  bool login = false;

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
            'https://firebasestorage.googleapis.com/v0/b/vehicle-rental-2.appspot.com/o/other%2Fcar2_background.jpg?alt=media&token=9336f54a-3200-4b30-b2dc-391379ca3a04', // Replace with the URL of your image
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            color: Colors.white.withOpacity(0.7), // Add a semi-transparent white background
            child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.all(14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ======== Full Name ========
                    login
                        ? Container()
                        : TextFormField(
                      key: ValueKey('fullname'),
                      decoration: InputDecoration(
                        hintText: 'Enter Full Name',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Full Name';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        setState(() {
                          fullname = value!;
                        });
                      },
                    ),

                    // ======== Email ========
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
                    // ======== Password ========
                    TextFormField(
                      key: ValueKey('password'),
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter Password',
                      ),
                      validator: (value) {
                        if (value!.length < 6) {
                          return 'Please Enter Password of at least 6 characters';
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
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 55,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            login
                                ? AuthServices.signinUser(
                                email, password, context)
                                : AuthServices.signupUser(
                                email, password, fullname, context);
                          }
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => IntroPage(
                                userName: fullname,
                                userEmail: email,
                              ),
                            ),
                          );
                        },
                        child: Text(login ? 'Login' : 'Register'),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          login = !login;
                        });

                        // Navigate to the login page when switching to login mode
                        if (login) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        }
                      },
                      child: Text(login
                          ? "Don't have an account? Signup"
                          : "Already have an account? Login"),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

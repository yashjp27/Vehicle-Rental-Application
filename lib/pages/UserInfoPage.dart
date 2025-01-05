import 'dart:html';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UserInfoPage extends StatefulWidget {
  final String email;

  UserInfoPage({required this.email});

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  String name = '';
  String age = '';
  String country = '';
  String mobileNumber = '';
  String imagePath = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  bool isEditingName = false;
  bool isEditingAge = false;
  bool isEditingCountry = false;
  bool isEditingMobile = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  void dispose() {
    // Add any cleanup or resource release code here
    super.dispose();
  }

  void fetchUserData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final userData = snapshot.docs.first.data() as Map<String, dynamic>;

        setState(() {
          name = userData['name'] ?? '';
          age = userData['age'] ?? '';
          country = userData['country'] ?? '';
          mobileNumber = userData['mobileNumber'] ?? '';
          imagePath = userData['imagePath'] ?? '';
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void updateField(String field, String newValue) async {
    try {
      final dataToUpdate = {field: newValue};
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final DocumentSnapshot userDocument = snapshot.docs.first;
        final String documentId = userDocument.id;

        // Update the specific field of the document
        await FirebaseFirestore.instance.collection('users').doc(documentId).update(dataToUpdate);

        setState(() {
          switch (field) {
            case 'name':
              name = newValue;
              break;
            case 'age':
              age = newValue;
              break;
            case 'country':
              country = newValue;
              break;
            case 'mobileNumber':
              mobileNumber = newValue;
              break;
          }
        });
      } else {
        print('User document not found for email: ${widget.email}');
      }
    } catch (e) {
      print('Error updating $field: $e');
    }
  }

  Future<void> uploadImageToFirebase() async {
    // Create an input element
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.click();

    // On change call method with event e
    uploadInput.onChange.listen((e) async {
      // Read file (image) as dataUrl and call putString method with this data
      final files = uploadInput.files;
      if (files!.length == 1) {
        final file = files[0];
        final reader = html.FileReader();

        reader.onLoadEnd.listen((e) async {
          final storage = FirebaseStorage.instanceFor(bucket: "vehicle-rental-2.appspot.com");

          // Extract the image's filename from the path
          final filename = file.name;

          // Create a reference to the location you want to upload to in Firebase
          var ref = storage.ref().child("images/$filename");

          // Upload the file to Firebase
          var uploadTaskSnapshot = await ref.putBlob(file);

          // When complete, get the download URL
          String downloadUrl = await uploadTaskSnapshot.ref.getDownloadURL();
          print('Image uploaded successfully, download URL: $downloadUrl');

          // Update the imagePath field in the document
          updateImagePath(downloadUrl);
        });
        reader.readAsDataUrl(file);
      }
    });
  }

  void updateImagePath(String imagePath) {
    updateField('imagePath', imagePath);
    setState(() {
      this.imagePath = imagePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display an image if imagePath is not empty, otherwise display the uploaded image
            if (imagePath.isNotEmpty)
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(imagePath),
              )
            else if (imagePath.isEmpty)
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey, // Background color
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white, // Icon color
                ),
              ),
            SizedBox(height: 24), // Increased spacing here

            _buildEditField(
              'Name',
              name,
              isEditingName,
              nameController,
              'New Name',
              'name',
            ),
            _buildEditField(
              'Age',
              age,
              isEditingAge,
              ageController,
              'New Age',
              'age',
            ),
            _buildEditField(
              'Country',
              country,
              isEditingCountry,
              countryController,
              'New Country',
              'country',
            ),
            _buildEditField(
              'Mobile Number',
              mobileNumber,
              isEditingMobile,
              mobileNumberController,
              'New Mobile Number',
              'mobileNumber',
            ),
            SizedBox(height: 24), // Increased spacing here
            ElevatedButton(
              onPressed: () async {
                await uploadImageToFirebase();
              },
              child: Text('Change Image'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEditField(
      String label,
      String value,
      bool isEditing, // This variable controls the editing state
      TextEditingController controller,
      String hintText,
      String field,
      ) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              '$label: ${value.isNotEmpty ? value : 'Not set'}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        if (!isEditing)
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    controller.text = value; // Set the text field to the existing value
                    isEditing = true; // Update the editing state
                  });
                },
                child: Text(value.isEmpty ? 'Add $label' : 'Change $label'),
              ),
            ],
          ),
        if (isEditing)
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hintText,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    updateField(field, controller.text);
                  }
                  setState(() {
                    isEditing = false;
                  });
                },
                child: Text('Submit'),
              ),
            ],
          ),
        SizedBox(height: 16),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ContactsDetailsPage extends StatefulWidget {
  @override
  _ContactsDetailsPageState createState() => _ContactsDetailsPageState();
}

class _ContactsDetailsPageState extends State<ContactsDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts Details'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.pinkAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: _buildGlowingText(
                'Contact Mail',
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                colors: [Colors.white, Colors.pinkAccent],
              ),
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('contacts').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  return SingleChildScrollView(
                    child: Column(
                      children: snapshot.data!.docs.map((doc) {
                        var data = doc.data();
                        var email = data['email'] as String? ?? '';
                        var message = data['message'] as String? ?? '';
                        var name = data['name'] as String? ?? '';
                        var timestamp = (data['timestamp'] as Timestamp?) ?? Timestamp.now();

                        // Extract the date and time from the timestamp
                        var date = timestamp.toDate().toLocal();
                        var formattedDate = DateFormat.yMMMd().format(date);
                        var formattedTime = DateFormat.jm().format(date);

                        return Card(
                          margin: EdgeInsets.all(10),
                          child: ListTile(
                            title: Text(
                              'Name: $name',
                              style: TextStyle(fontSize: 18),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email: $email',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Message: $message',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Date: $formattedDate',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Time: $formattedTime',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                } else {
                  return Center(
                    child: Text('No contact details available.'),
                  );
                }
              },
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

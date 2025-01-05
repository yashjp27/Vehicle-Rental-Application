import 'package:flutter/material.dart';
import 'RentPage.dart';


class VehicleSearch2Page extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String name;
  final String imageUrl;
  final int pricePerHour;
  final int pricePerDay;
  final String vehicleType;
  final String pickupLocation;
  final String dropOffLocation;

  VehicleSearch2Page({
    required this.userName,
    required this.userEmail,
    required this.name,
    required this.imageUrl,
    required this.pricePerHour,
    required this.pricePerDay,
    required this.vehicleType,
    required this.pickupLocation,
    required this.dropOffLocation,
  });

  @override
  _VehicleSearch2PageState createState() => _VehicleSearch2PageState();
}

class _VehicleSearch2PageState extends State<VehicleSearch2Page> {
  DateTime? pickupDate;
  DateTime? dropOffDate;
  TimeOfDay? pickupTime;
  TimeOfDay? dropOffTime;
  String picktime = '';
  String droptime ='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VR Recommender'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "VR Recommender",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 24.0,
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Pick-up Time"),
                          SizedBox(height: 8.0),
                          GestureDetector(
                            onTap: () {
                              _selectTime(context, pickupTime, (time) {
                                setState(() {
                                  pickupTime = time;
                                });
                              });
                            },
                            child: Row(
                              children: [
                                Icon(Icons.access_time),
                                SizedBox(width: 8.0),
                                Text(
                                  pickupTime == null
                                      ? 'Select pick-up time'
                                      : '${pickupTime!.hour}:${pickupTime!.minute}',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Pick-up Date"),
                          SizedBox(height: 8.0),
                          InkWell(
                            onTap: () {
                              _selectPickupDate(context);
                            },
                            child: InputDecorator(
                              decoration: InputDecoration(
                                hintText: 'Select pick-up date',
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(
                                  Icons.calendar_today,
                                  color: Colors.blue,
                                ),
                              ),
                              child: Text(
                                pickupDate == null
                                    ? 'Select pick-up date'
                                    : '${pickupDate!.toLocal()}'
                                    .split(' ')[0],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Drop-off Time"),
                          SizedBox(height: 8.0),
                          GestureDetector(
                            onTap: () {
                              _selectTime(context, dropOffTime, (time) {
                                setState(() {
                                  dropOffTime = time;
                                });
                              });
                            },
                            child: Row(
                              children: [
                                Icon(Icons.access_time),
                                SizedBox(width: 8.0),
                                Text(
                                  dropOffTime == null
                                      ? 'Select drop-off time'
                                      : '${dropOffTime!.hour}:${dropOffTime!.minute}',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Drop-off Date"),
                          SizedBox(height: 8.0),
                          InkWell(
                            onTap: () {
                              _selectDropOffDate(context);
                            },
                            child: InputDecorator(
                              decoration: InputDecoration(
                                hintText: 'Select drop-off date',
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(
                                  Icons.calendar_today,
                                  color: Colors.blue,
                                ),
                              ),
                              child: Text(
                                dropOffDate == null
                                    ? 'Select drop-off date'
                                    : '${dropOffDate!.toLocal()}'
                                    .split(' ')[0],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _handleSearch,
                  child: Text('Continue'),
                ),
                // Display search results
                // ...
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectTime(
      BuildContext context, TimeOfDay? initialTime, Function(TimeOfDay) onTimeSelected) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
    );

    if (selectedTime != null) {
      onTimeSelected(selectedTime);
    }
  }

  Future<void> _selectPickupDate(BuildContext context) async {
    final currentDate = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: pickupDate ?? currentDate,
      firstDate: currentDate,
      lastDate: currentDate.add(Duration(days: 365)),
    );

    if (selectedDate != null) {
      setState(() {
        pickupDate = selectedDate;
      });
    }
  }

  Future<void> _selectDropOffDate(BuildContext context) async {
    final currentDate = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: dropOffDate ?? currentDate,
      firstDate: currentDate,
      lastDate: currentDate.add(Duration(days: 365)),
    );

    if (selectedDate != null) {
      setState(() {
        dropOffDate = selectedDate;
      });
    }
  }

  Future<void> _handleSearch() async {

    String pickupTimeStr =
        '${pickupTime!.hour}:${pickupTime!.minute}';
    String dropOffTimeStr =
        '${dropOffTime!.hour}:${dropOffTime!.minute}';
    picktime = pickupTimeStr;
    droptime = dropOffTimeStr;

    try {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RentPage(
            name: widget.name,
            type: widget.vehicleType,
            imageUrl: widget.imageUrl,
            pricePerHour: widget.pricePerHour,
            pricePerDay: widget.pricePerDay,
            userName: widget.userName,
            userEmail: widget.userEmail,
            pickdate: pickupDate!,
            picktime: picktime,
            picklocation: widget.pickupLocation,
            dropdate: dropOffDate!,
            droptime: droptime,
            droplocation: widget.dropOffLocation,
          ),
        ),
      );
    } catch (error) {
      print('Error during search: $error');
    }
  }
}

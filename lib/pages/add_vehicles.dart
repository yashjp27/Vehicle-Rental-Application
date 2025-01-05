import 'firestore_service.dart'; // Import your Firestore service file here
import 'package:image_picker/image_picker.dart';

final firestoreService = FirestoreService();

Future<void> addVehiclesToFirestore() async {
  // Check if a vehicle with the same name already exists
  final existingVehicle = await firestoreService.getVehicleByName('Tata Nano');

  if (existingVehicle == null) {
    // If the vehicle doesn't exist, add it to Firestore
    await firestoreService.addVehicle(
      'Tata Nano',
      "https://firebasestorage.googleapis.com/v0/b/vehicle-rental-2.appspot.com/o/vehicle_images%2Fvehicle_1.jpg?alt=media&token=9124dc24-00af-487a-a6a9-1d4e156b2254",
      105, // Price per hour
      1449, // Price per day
      'Car', // Type
      ['Borivali','Andheri','Churchgate'],
      ['Andheri','Virar'],
    );

    print('Tata Nano added to Firestore');
  } else {
    // If the vehicle already exists, you can choose to update its details or handle it accordingly
    print('Tata Nano already exists in Firestore');
  }

  // Check if a vehicle with the same name already exists
  final existingVehicle75 = await firestoreService.getVehicleByName('Western Star 4900');

  if (existingVehicle75 == null) {
    // If the vehicle doesn't exist, add it to Firestore
    await firestoreService.addVehicle(
      'Western Star 4900',
      "https://firebasestorage.googleapis.com/v0/b/vehicle-rental-2.appspot.com/o/vehicle_images%2Fvehicle_75.jpeg?alt=media&token=984eaf47-c54a-49b8-ab73-c6a53a4b3aba",
      285, // Price per hour
      3000, // Price per day
      'Truck', // Type
      ['Borivali','Kandivali','Virar','Vasai Road','Dadar','Bandra','Marine Lines','Nala Sopara','Bhayandar','Mahim','Churchgate','Thane'],
      ['Borivali','Kandivali','Virar','Vasai Road','Dadar','Bandra','Marine Lines','Nala Sopara','Bhayandar','Mahim','Churchgate','Thane'],
    );

    print('Western Star 4900 added to Firestore');
  } else {
    // If the vehicle already exists, you can choose to update its details or handle it accordingly
    print('Western Star 4900 already exists in Firestore');
  }


  print('Vehicles added to Firestore');
}

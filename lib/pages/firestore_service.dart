import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addVehicle(
      String name,
      String imageUrl,
      int pricePerHour,
      int pricePerDay,
      String type,
      List<String> pickupLocation,
      List<String> dropOffLocation,
      ) async {
    try {
      // Reference to the "vehicles" collection
      CollectionReference vehiclesCollection = _firestore.collection('vehicles');

      // Check if a vehicle with the same name already exists
      final existingVehicle = await getVehicleByName(name);

      if (existingVehicle == null) {
        // If the vehicle doesn't exist, add it as a new document
        await vehiclesCollection.add({
          'name': name,
          'imageUrl': imageUrl,
          'pricePerHour': pricePerHour,
          'pricePerDay': pricePerDay,
          'type': type,
          'pickupLocation': pickupLocation,
          'dropOffLocation': dropOffLocation,
        });

        print('$name added to Firestore');
      }
    } catch (e) {
      print('Error adding/updating vehicle: $e');
    }
  }

  Future<List<DocumentSnapshot>> getVehicles() async {
    final QuerySnapshot querySnapshot = await _firestore.collection('vehicles').get();
    return querySnapshot.docs;
  }
  Future<DocumentSnapshot?> getVehicleByName(String name) async {
    try {
      final vehicleQuery = await _firestore
          .collection('vehicles')
          .where('name', isEqualTo: name)
          .get();

      if (vehicleQuery.docs.isNotEmpty) {
        return vehicleQuery.docs.first;
      }

      return null;
    } catch (e) {
      print('Error getting vehicle by name: $e');
      return null;
    }
  }
}

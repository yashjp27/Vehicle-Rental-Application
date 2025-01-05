const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.syncPickupLocation = functions.firestore
    .document('vehicles/{vehicleId}')
    .onUpdate((change, context) => {
        const newValue = change.after.data();
        const previousValue = change.before.data();

        // Check if 'pickupLocation' has changed for the 'TATA NANO' vehicle
        if (newValue.name === 'Tata Nano' && newValue.pickupLocation !== previousValue.pickupLocation) {
            // Update the Firestore document with the new 'pickupLocation'
            return admin.firestore().collection('vehicles').doc(context.params.vehicleId)
                .update({
                    pickupLocation: newValue.pickupLocation
                });
        }

        return null;
    });

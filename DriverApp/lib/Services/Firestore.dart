

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
String status='';

class Firestore_services {

  Future<void> saveUserData(String Uid, String email, String username,
      String phone) async {
    try {
      await FirebaseFirestore.instance.collection('drivers').doc(Uid).set({
        'username': username,
        'email': email,
        'phone': phone,
        // 'carModel':CarModel,

      });
    } catch (e) {
      print('Error saving user data: $e');
      // Handle data saving errors here.
    }
  }

  Future<void> saveRideData(String status, String start, String destination,
      String spots, String price, String date, String time,
      String ? uid) async {
    try {
      await FirebaseFirestore.instance.collection('rides').add({
        'status': status,
        'start': start,
        'destination': destination,
        'spots': spots,
        'price': price,
        'date': date,
        'time': time,
        'DriverId': uid,
      });
    } catch (e) {
      print('Error saving user data: $e');
      // Handle data saving errors here.
    }
  }

  Future<List> fetchRides(String status) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      CollectionReference userRef = FirebaseFirestore.instance.collection(
          'rides');
      QuerySnapshot querySnapshot;

      if (status.isEmpty) {
        querySnapshot = await userRef.where('DriverId', isEqualTo: uid).get();
      } else {
        querySnapshot = await userRef
            .where('DriverId', isEqualTo: uid)
            .where('status', isEqualTo: status)
            .get();
      }

      List mydoc = querySnapshot.docs;
      return mydoc;
    }
    return [];
  }




  Future<List> fetchRequests(String status) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      CollectionReference userRef = FirebaseFirestore.instance.collection('requests');
      QuerySnapshot querySnapshot;

      if (status.isEmpty) {
        querySnapshot = await userRef.where('DriverId', isEqualTo: uid).get();
      } else {
        querySnapshot = await userRef.where('DriverId', isEqualTo: uid)
            .where('RequestStatus', isEqualTo: status)
            .get();
      }

      List mydoc = querySnapshot.docs;
      return mydoc;
    }
    return [];
  }

  Future<Map<String, dynamic>> fetchUserProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      var userRef = FirebaseFirestore.instance.collection('drivers').doc(uid);
      var documentSnapshot = await userRef.get();

      return documentSnapshot.data() ?? {};
    }

    return {};
  }
  //update  status for the requests collection
  Future<void> updateStatus(String id,String status) async {
    try {
      // Get the document reference
      await FirebaseFirestore.instance.collection('requests').doc(id).update({'RequestStatus': status});

    }
    catch (e) {
      print('Error updating status to pending: $e');
    }
  }
//update the ride status
  Future<void> updateRideStatus(String ? rideId, String newStatus) async {
    try {
      print('Updating ride status for ride ID: $rideId'); // Debugging print
      await FirebaseFirestore.instance.collection('rides').doc(rideId).update({'status': newStatus});
      print('Ride status updated successfully!');

    }
    catch (e) {
      print('Error updating ride status: $e');
      // Handle the error as needed
    }
  }



  Future<void> updateRideOnCondition() async {
    try {
      // Fetch data that you need to check conditions against
      List requests = await fetchRequests(status);

      if (requests.isNotEmpty) {
        for (int index = 0; index < requests.length; index++) {
          try {
            String dateTime = requests[index].data()['RideDate'];
            DateTime date =DateTime.parse(dateTime);
            print(date.year);
            String rideTime = requests[index].data()['RideTime']; // Assuming '7:30 AM' is stored in rideTime
            //Trim leading/trailing spaces
            rideTime = rideTime.trim();
            // Replace non-breaking space with regular space if needed
            rideTime = rideTime.replaceAll('\u00A0', ' ');
            DateFormat format = DateFormat('h:mm a');
            DateTime time = format.parse(rideTime);
            print(time.minute);
            DateTime currentTime = DateTime.now();
            DateTime delayTime = DateTime(date.year, date.month, date.day, time.hour + 2, time.minute +30);

            if (requests[index].data()['RequestStatus'] == 'approved' && currentTime==time) {
              await updateRideStatus(requests[index].data()['RideID'], 'active');
            } else if (requests[index].data()['RequestStatus'] == 'rejected' ) {

              await updateRideStatus(requests[index].data()['RideID'], 'canceled');
            } else if (requests[index].data()['RequestStatus'] == 'approved' && currentTime.isAfter(delayTime)) {

              await updateRideStatus(requests[index].data()['RideID'], 'completed');
            }
            else if (requests[index].data()['RequestStatus'] == 'expired' ) {

              await updateRideStatus(requests[index].data()['RideID'], 'canceled');
            }
            else if (requests[index].data()['RequestStatus'] == 'full trip' ) {

              await updateRideStatus(requests[index].data()['RideID'], 'Full');
            }

            else {
              await updateRideStatus(requests[index].data()['RideID'], 'waiting');
            }
          } catch (e) {
            print('Error in processing request ${requests[index].data()['RideID']}: $e');
          }
        }
      }
    } catch (e) {
      print('Error updating ride statuses: $e');
    }


  }
  DeleteData(CollectionReference userRef,String id){
    userRef.doc(id).delete();
  }

}
// //general method used to fetch by giving it collection reference
// Future<List<DocumentSnapshot>> fetchData1(CollectionReference userRef) async {
//   try {
//     QuerySnapshot querySnapshot = await userRef.get();
//     if (querySnapshot.docs.isNotEmpty) {
//       return querySnapshot.docs;
//     }
//   } catch (e) {
//     print('Error fetching data: $e');
//   }
//   // Return an empty list if no documents match the query or if there's an error
//   return [];
// }
//var userRef1 = FirebaseFirestore.instance.collection('requests');

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

String status='';
class Firestore_services{


  Future<bool> checkUserExistsInFirestore(String email, String password) async {
    // Ensure your Firestore query is correctly checking for user existence
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      return query.docs
          .isNotEmpty; // Returns true if there are documents matching the email
    } catch (e) {
      // Handle any potential errors during the Firestore query
      print('Error checking user existence: $e');
      return false;
    }
  }
  //used to ensure that the user request the ride only once at a time
  Future<bool> checkExistingRequest(String rideId,String uid) async {
    try {
      // Check if a document exists with the same rideId and userID
      var rideRef = FirebaseFirestore.instance.collection('requests')
          .where('RideID', isEqualTo: rideId)
          .where('userID', isEqualTo: uid);

      var rideQuery = await rideRef.get();
      return rideQuery.docs.isNotEmpty;
    } catch (e) {
      print('Error checking existing request: $e');
      return false;
    }
  }

  // function used to save user data in collection users
  Future<void> saveUserData(String Uid, String email, String username,
      String phone) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(Uid).set({
        'username': username,
        'email': email,
        'phone': phone,

      });
    } catch (e) {
      print('Error saving user data: $e');
      // Handle data saving errors here.
    }
  }
  // function used to save request data in collection request

  Future <void> SaveRequestData (String ? uid, String ? email ,String ? start ,String ? destination
      ,String ?rideId , String ? RideDate,String ? RideTime,String ?RequestStatus , String ? DriverID) async{
    await FirebaseFirestore.instance.collection('requests').add({
      'userID': uid,
      'email': email,
      'start': start,
      'destination':destination,
      'RideID': rideId,
      'RideDate': RideDate,
      'RideTime':RideTime,
      'RequestStatus':RequestStatus,
      'DriverId':DriverID,
    });

  }

// fetch from requests collection and perform searching by status
  Future<List> fetchRequestdata(String status) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      var userRef = FirebaseFirestore.instance.collection('requests');
      QuerySnapshot querySnapshot;

      if (status.isEmpty) {
        querySnapshot = await userRef.where('userID', isEqualTo: uid).get();
      } else {
        querySnapshot = await userRef.where('userID', isEqualTo: uid)
            .where('RequestStatus', isEqualTo: status)
            .get();
      }

      List mydoc = querySnapshot.docs;
      return mydoc;
    }
    return [];
  }
  // function used to fetchh rideStatus data in collection rides

  Future<String?> fetchRideStatus(String rideId) async {
    try {

      DocumentSnapshot rideSnapshot = await FirebaseFirestore.instance
          .collection('rides').doc(rideId).get();

      if (rideSnapshot.exists) {
        Map<String, dynamic> rideData = rideSnapshot.data() as Map<String, dynamic>;
        String? rideStatus = rideData['status'] as String?;
        return rideStatus;
      } else {
        return null; // Ride not found or data is empty
      }
    }
    catch (e) {
      print('Error fetching ride status: $e');
      return null; // Error occurred during fetch
    }
  }
  Future<Map<String, dynamic>> fetchUserProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      var userRef = FirebaseFirestore.instance.collection('users').doc(uid);
      var documentSnapshot = await userRef.get();
      return documentSnapshot.data() ?? {};
    }
    return {};

  }
  Future<List<QueryDocumentSnapshot<Object?>>> fetchOption1() async {
    final QuerySnapshot ridesSnapshot = await FirebaseFirestore.instance
        .collection('rides')
        .where('time', isEqualTo: '7:30 AM') // Replace 'time' with your time field
        .get();

    return ridesSnapshot.docs;
  }
  Future<List<QueryDocumentSnapshot<Object?>>> fetchOption2() async {
    final QuerySnapshot ridesSnapshot = await FirebaseFirestore.instance
        .collection('rides')
        .where('time', isEqualTo: '5:30 PM') // Replace 'time' with your time field
        .get();

    return ridesSnapshot.docs;
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
  // var userRef1 = FirebaseFirestore.instance.collection('requests');

  Future<void> updateRideOnCondition() async {
    try {
      // Fetch data that you need to check conditions against
      List requests = await fetchRequestdata(status);

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
// // general function for fetching data and specify the collection reference as a parameter
//   Future<List<DocumentSnapshot>> fetchData1(CollectionReference userRef) async {
//     try {
//       QuerySnapshot querySnapshot = await userRef.get();
//       if (querySnapshot.docs.isNotEmpty) {
//         return querySnapshot.docs;
//       }
//     } catch (e) {
//       print('Error fetching data: $e');
//     }
//     // Return an empty list if no documents match the query or if there's an error
//     return [];
//   }

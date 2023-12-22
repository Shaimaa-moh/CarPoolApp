import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/Models/Firestore.dart';

import 'OrderHistory.dart';


DateTime time_now =DateTime.now();
String time =  time_now.hour.toString().padLeft(2, '0');
final uid = FirebaseAuth.instance.currentUser?.uid;
final username = FirebaseAuth.instance.currentUser?.displayName;
final email = FirebaseAuth.instance.currentUser?.email;
Firestore_services _firestore =Firestore_services();
String rideId="";
String status = "pending";

class TripDetails extends StatefulWidget {
  const TripDetails({super.key});

  @override
  State<TripDetails> createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {



  @override
  Widget build(BuildContext context) {
    Map Data = ModalRoute.of(context)!.settings.arguments as Map;
    rideId = Data['rideId'];
    String start = Data['start'];
    String destination = Data['destination'];
    String RideID =Data['rideId'];
    String RideDate =Data['date'];
    String RideTime =Data['time'];
    String DriverID = Data['DriverId'];
    String RequestStatus =status;
    DateTime date = DateTime.parse(Data['date']);
    DateTime reservationTime= DateTime(time_now.year, time_now.month, time_now.day, time_now.hour, time_now.minute);

    print(rideId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip details', style: TextStyle(color:Colors.white,
        fontSize: 28,
        fontFamily: 'Courier',),),
        backgroundColor: Colors.grey.shade900,
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.start,
                 children:[

                   Text('Status: ${Data['RideStatus']}',style: const TextStyle(fontSize: 20 , color: Colors.indigoAccent),
                   ),
                   const SizedBox(
                     height: 15,
                   ),
                     Text('Start: ${Data['start']}',style: const TextStyle(fontSize: 20),
                  ),
                   const SizedBox(
                     height: 15,
                   ),
                   Text('Destination: ${Data['destination']}',style: const TextStyle(fontSize: 20),
                   ),
                   const SizedBox(
                     height: 15,
                   ),

                   Text('Date: ${Data['date'].toString()}' ,style: const TextStyle(fontSize: 20)),
                   const SizedBox(
                     height: 15,
                   ),

                   Text('Time: ${Data['time'].toString()}' ,style: const TextStyle(fontSize: 20)),
                   const SizedBox(
                     height: 15,
                   ),
                   Text('Price : ${Data['price']}' ,style: const TextStyle(fontSize: 20)),
                   const SizedBox(
                     height: 15,
                   ),
                   const Text('Adjust price',style: TextStyle(
                     fontSize: 20,
                     color: Colors.pinkAccent,
                   )),
                   const SizedBox(
                     height: 15,
                   ),
                   const TextField(
                     decoration: InputDecoration(
                       border: OutlineInputBorder(),
                       hintText: 'Enter Price',
                     ),
                   ),
                   const SizedBox(
                     height: 15,
                   ),
          Center(
              child:SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: () async {

                      if(Data['time'].toString()=='7:30 AM') {
                        DateTime rideTime = DateTime(date.year, date.month, date.day, 7, 30);
                        DateTime reservationDeadline= DateTime(date.year, date.month, date.day -1, 22, 00);
                        if (reservationTime.isBefore(reservationDeadline) && reservationTime.isBefore(rideTime)) {
                  print('Reservation done successfully');
                  await _firestore.SaveRequestData(uid, email, start, destination, RideID, RideDate, RideTime, RequestStatus,DriverID);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Request done successfully , waiting for driver accept.'),
                    ),

                  );

                }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('error: Reservation for the ride at 7:30 am is closed.'),
                    ),
                  );
                }
              }
              else if(Data['time'].toString()=='5:30 PM') {

                        DateTime rideTime = DateTime(date.year, date.month, date.day, 17, 30);
                        DateTime reservationDeadline= DateTime(date.year, date.month, date.day , 13, 00);
                        print(time);

                if (reservationTime.isBefore(reservationDeadline) && reservationTime.isBefore(rideTime)) {
                  print('Reservation done successfully');

                  await _firestore.SaveRequestData(uid, email, start, destination, RideID, RideDate, RideTime, RequestStatus,DriverID);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Request done successfully!'),
                    ),
                  );   }

                else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('error: Reservation for the ride at 5:30pm is closed.'),
                    ),
                  );
                }
              }

             }, child: const Text('Add to Cart',style: TextStyle(color: Colors.white, fontSize: 20,))),
              ),
            ),

          SizedBox(
            height: 15,
          ),
          Center(
            child:SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(16),
                ),
                  onPressed: () async{

                    print(status);
                    bool hasExistingRequest = await _firestore.checkExistingRequest(rideId,uid!);
                    if (!hasExistingRequest){

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Take care you passed time constraints'),
                        ),
                      );

                    await _firestore.SaveRequestData(uid, email, start, destination, RideID, RideDate, RideTime, RequestStatus,DriverID);
                      print(status);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Reservation done successfully , check your card'),
                        ),
                      );

                    }
                  else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('User has already requested this ride.'),
                        ),
                      );

                    }

              }, child: Text('Pass time',style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                )),),
            ),
          ),

                   InkWell(
                     child: Padding(
                       padding: const EdgeInsets.only(top:140,left:310),
                       child: FloatingActionButton(
                         onPressed: () {
                           Navigator.of(context).push(MaterialPageRoute(builder: (context) => const OrderHistory(),));
                         },
                         backgroundColor: Colors.white,
                         child: const Icon(
                           Icons.shopping_cart_outlined,
                           color: Colors.pinkAccent,
                         ),
                       ),
                     ),
                   ),

          ]),
        ),

      ));
  }
}


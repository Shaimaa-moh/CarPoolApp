import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Services/Firestore.dart';

class showRequests extends StatefulWidget {
  const showRequests({super.key});

  @override
  State<showRequests> createState() => _showRequestsState();
}

Firestore_services _firestore =Firestore_services();
int no_of_seats_per_trip = 0;
String status ='';
DateTime time_now=DateTime.now();
DateTime confirmTime = DateTime(time_now.year,time_now.month,time_now.day,time_now.hour,time_now.minute);
TextEditingController _searchbar=TextEditingController();
List<DocumentSnapshot> myRequests = [];
var userRef = FirebaseFirestore.instance.collection('requests');

class _showRequestsState extends State<showRequests> {
  List<int> itemCounts = List.generate(10, (index) => index + 1);
  final uid = FirebaseAuth.instance.currentUser?.uid;

  Future<void> fetchData() async {
    try {
      final snapshot = await _firestore.fetchRequests(status);
      setState(() {
        myRequests = snapshot as List<DocumentSnapshot>;
    });
    }catch (e) {
      print('Error fetching data: $e');
    }
  }

@override
  void initState() {
    super.initState();
    _firestore.updateRideOnCondition();
    fetchData();


}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My requests',style: TextStyle(
          color: Colors.white,
        ),),
        backgroundColor: Colors.grey.shade900,
        leading: const BackButton(color: Colors.white,),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade900,

      body: Column(

        children: [

                Expanded(
                child: ListView.builder(
                itemCount: myRequests.length,
                itemBuilder: (context, index) {
                String requestId = myRequests[index].id;

                  return Card(
                  elevation: 5,
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text('Request $index'),

                        Text('RideId: ${myRequests[index]['RideID']}'),
                        Text('userID : ${myRequests[index]['userID']}'),
                        Text('email : ${myRequests[index]['email']}'),
                        Text('RequestStatus : ${myRequests[index]['RequestStatus']}',style: const TextStyle(
                          color: Colors.cyan)
                        ),
                        Text('Start: ${myRequests[index]['start']}'),
                        Text('Destination: ${myRequests[index]['destination']}'),
                        Text('time : ${myRequests[index]['RideTime']}'),
                        Text('date : ${myRequests[index]['RideDate']}'),

                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [

                                 ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                    shape: MaterialStateProperty.all<OutlinedBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ))),
                                  onPressed:   () async{

                                  print(no_of_seats_per_trip);
                                    if(no_of_seats_per_trip >5){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('error : number of seats is completed '),));
                                    }
                                  var requestData = myRequests[index].data();
                                  print(requestData);
                                  if (requestData != null) {
                                    DateTime date= DateTime.parse(myRequests[index]['RideDate']);
                                    if (myRequests[index]['RideTime'] == '7:30 AM' && myRequests[index]['RequestStatus'] == 'pending') {
                                      DateTime rideTime = DateTime(date.year, date.month, date.day , 7, 30);
                                      DateTime requestConfirmDeadline = DateTime(date.year, date.month, date.day -1, 23, 30);

                                      if (confirmTime.isBefore(requestConfirmDeadline) && confirmTime.isBefore(rideTime)) {
                                        print('request approved');
                                        no_of_seats_per_trip +=1;
                                        while(no_of_seats_per_trip <5) {
                                          await _firestore.updateStatus(requestId, "approved");
                                        }

                                      }
                                      else if (rideTime.isAfter(requestConfirmDeadline)) {
                                        await  _firestore.updateStatus(requestId,"expired");
                                        print('request is expired');
                                      }
                                    }
                                    else if (myRequests[index]['RideTime'] == '5:30 PM' && myRequests[index]['RequestStatus'] == 'pending') {
                                      DateTime rideTime = DateTime(date.year, date.month, date.day , 17, 30);
                                      DateTime requestConfirmDeadline = DateTime(date.year, date.month, date.day , 16, 30);
                                      if (confirmTime.isBefore(requestConfirmDeadline) && confirmTime.isBefore(rideTime)) {
                                        no_of_seats_per_trip +=1;
                                        print('request approved');
                                        while(no_of_seats_per_trip <5){
                                          await  _firestore.updateStatus(requestId,"approved");

                                        }
                                      }
                                      if (rideTime.isAfter(requestConfirmDeadline)) {
                                        await  _firestore.updateStatus(requestId,"expired");
                                        print('request is expired');
                                      }
                                      if(no_of_seats_per_trip==5){
                                        await  _firestore.updateStatus(requestId,"full trip");
                                      }
                                    }
                                  }
                                  setState(() {
                                    // Remove the card when accepted
                                    myRequests.removeAt(index);
                                  });
                                     },child: const Text('Accept',style: TextStyle(
                                  color: Colors.green,),),)
                                ,


                            const SizedBox(width: 10,),
                            ElevatedButton(

                            style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                  shape: MaterialStateProperty.all<OutlinedBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ))),
                              onPressed: () async{


                                if(no_of_seats_per_trip >5 ){
                                print('request is rejected');
                                await  _firestore.updateStatus(requestId,"rejected");
                              }
                              else{
                               _showMyDialog(context);
                                await  _firestore.updateStatus(requestId,"rejected");

                              }
                                setState(() {
                                  // Remove the card when accepted
                                  myRequests.removeAt(index);
                                });

                                } ,
                              child: const Text('Reject', style: TextStyle(
                                color: Colors.red,
                              ),),)
                          ]),
                          ],
                        )


                    ),
                  );


                }
                ))
    ]
    )


    );
  }
}
Future<void> _showMyDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context)
    {
      return AlertDialog(
        title: const Text('Confirmation'),
        content: const SingleChildScrollView(
          child: Text('Make sure you want to cancel request'),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

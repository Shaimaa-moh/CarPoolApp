import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/Controller/Auth2.dart';
import 'package:project/Models/Firestore.dart';
import 'package:project/Screens/OrderHistory.dart';

class RequestTrip2 extends StatefulWidget {
  const RequestTrip2({super.key});

  @override
  State<RequestTrip2> createState() => _RequestTrip2State();
}

AuthServices mydata = AuthServices();
Firestore_services _firestore =Firestore_services();

List mylist = [];
String status = "";
String selectedRideId='';

DateTime time_now = DateTime.now();


var userRef = FirebaseFirestore.instance.collection('rides');
var userRef1 = FirebaseFirestore.instance.collection('requests');

class _RequestTrip2State extends State<RequestTrip2> {


  @override
  void initState() {
    super.initState();
    _firestore.updateRideOnCondition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PickUp Location',style: TextStyle(
          fontFamily: "Courier",
          fontSize: 28,
        ),),
        backgroundColor: Colors.grey.shade900,
        centerTitle: true,
      ),

      body: Column(
        children: [
          Expanded(child: FutureBuilder(
              future: _firestore.fetchOption2(),
              builder: (context,snapshot){
                if(snapshot.hasData){
                  mylist = snapshot.data!;
                  return ListView.builder(
                      itemCount: mylist.length,
                      itemBuilder: (context,index) {
                        return Card(
                          color: Colors.white24,
                          elevation: 4,
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text('driverId : ${mylist[index].data()['DriverId'] }',
                                        style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('Status : ${mylist[index].data()['status'] ?? 'No status available'}',
                                        style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.indigoAccent)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('Start : ${mylist[index].data()['start']}'),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('Destination : ${mylist[index].data()['destination']}'),
                                  ],
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text('Spots available : ${mylist[index].data()['spots']}'),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text('Price : ${mylist[index].data()['price']}'),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text('date : ${mylist[index].data()['date']}'),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text('time : ${mylist[index].data()['time']}'),

                                  ],
                                ),
                              ),
                              leading: CircleAvatar(
                                backgroundColor: Colors.indigo,
                                child: const Icon(Icons.train_outlined),),
                              // trailing: IconButton(
                              //   icon: const Icon(Icons.add,),
                              //   onPressed: () {},
                              //   color: Colors.indigo,
                              // ),
                              onTap: ()  {
                                selectedRideId = mylist[index].id;
                                print (selectedRideId);
                                setState(() {

                                  print(selectedRideId); // Assuming your ride has an 'id' property
                                  Navigator.pushNamed(
                                    context, '/TripDetails', arguments: {
                                    'RideStatus':mylist[index].data()['status'],
                                    'start': mylist[index].data()['start'],
                                    'destination': mylist[index].data()['destination'],
                                    'spots': mylist[index].data()['spots'],
                                    'price': mylist[index].data()['price'],
                                    'date': mylist[index].data()['date'],
                                    'time': mylist[index].data()['time'],
                                    'DriverId': mylist[index].data()['DriverId'],
                                    'rideId': selectedRideId,

                                  },);

                                }
                                );
                              }),

                        );
                      }
                  );
                }
                else if(snapshot.hasError){
                  return Text("Error has occured in getting db data");
                }
                else{
                  return CircularProgressIndicator();
                }
              })),

          InkWell(
            child: Padding(
              padding: const EdgeInsets.only(left:310),
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

        ],
      ),
    );

  }
}




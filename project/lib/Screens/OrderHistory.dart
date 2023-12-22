import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/Models/Firestore.dart';
import 'package:project/Screens/PayVisa.dart';


final uid = FirebaseAuth.instance.currentUser?.uid;

var userRef1 = FirebaseFirestore.instance.collection('requests');

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

String rideId="";
String status="";

class _OrderHistoryState extends State<OrderHistory> {

  Firestore_services _firestore =Firestore_services();
  List requests=[];

  TextEditingController _searchbar = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (requests.isNotEmpty) {
      rideId = requests[0].data()['RideID'];
      _firestore.fetchRideStatus(rideId);
    }

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(
          'Orders History',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _searchbar,
              decoration: InputDecoration(
                hintText: 'Search by request status',
                hintStyle: const TextStyle(fontSize: 20.0, color: Colors.pinkAccent),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    setState(() {
                      status = _searchbar.text;
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _firestore.fetchRequestdata(status),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  requests = snapshot.data!;

                  return ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      if (requests[index].data()['userID'] == uid) {
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.all(8),
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FutureBuilder<String?>(
                                    future: _firestore.fetchRideStatus(requests[index].data()['RideID']),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error fetching ride status');
                                      } else {
                                        String? rideStatus = snapshot.data;
                                        return Text(
                                          'Ride status: ${rideStatus ?? "No status found"}',
                                          style: TextStyle(
                                            color: Colors.indigoAccent,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('Request status : ${requests[index].data()['RequestStatus']}'),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('Start : ${requests[index].data()['start']}'),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('Destination : ${requests[index].data()['destination']}'),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('RideID : ${requests[index].data()['RideID']}'),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('RideDate : ${requests[index].data()['RideDate']}'),
                                ],
                              ),
                            ),
                            leading: IconButton(
                              color: Colors.indigoAccent,
                              onPressed: () {
                                _firestore.DeleteData(userRef1, requests[index].id);
                                setState(() {});
                              },
                              icon: Icon(Icons.delete),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('time : ${requests[index].data()['RideTime']}'),
                                ],
                              ),
                            ),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const PayVisa(),
                                  ),
                                );
                              },
                              child: Text(
                                'Pay',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      }
                      return SizedBox.shrink();
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("Error has occurred in getting db data");
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

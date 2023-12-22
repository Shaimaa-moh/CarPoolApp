import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Services/Firestore.dart';


class Rides extends StatefulWidget {
  const Rides({super.key});

  @override
  State<Rides> createState() => _RidesState();
}

Firestore_services _firestore =Firestore_services();

List mylist = [];
String status = "";
String selectedRideId='';
DateTime time_now=DateTime.now();
TextEditingController _searchbar=TextEditingController();
var userRef = FirebaseFirestore.instance.collection('rides');



class _RidesState extends State<Rides> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Rides',style: TextStyle(
          fontFamily: "Courier",
          fontSize: 28,
          color: Colors.white,
        ),),
        backgroundColor: Colors.grey.shade900,
        centerTitle: true,
        leading: const BackButton(
          color:Colors.white,
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _searchbar,
              decoration: InputDecoration(
                  hintText: 'Search here',
                  hintStyle: const TextStyle(fontSize: 20.0, color: Colors.red),
                  suffixIcon: IconButton(
                    icon:  const Icon(Icons.search), onPressed: () async {
                    status = _searchbar.text;

                    setState(() {
                      });

                  },
                  )
              ),

            ),
          ),
          Expanded(child: FutureBuilder(
              future: _firestore.fetchRides(status),
              builder: (context,snapshot){
                if(snapshot.hasData){
                  mylist = snapshot.data!;
                  return ListView.builder(
                      itemCount: mylist.length,
                      itemBuilder: (context,index) {
                        return Card(
                          child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                     Text('status : ${mylist[index].data()['status']}'),
                                    Text('Start : ${mylist[index]
                                        .data()['start']}'),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text('Destination : ${mylist[index].data()['destination']}'),
                                  ],
                                ),
                              ),
                            leading: IconButton(
                              color: Colors.indigoAccent,
                              onPressed: () {
                                _firestore.DeleteData(userRef, mylist[index].id);
                                setState(() {});
                              },
                              icon: const Icon(Icons.delete),
                            ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  Text('Price : ${mylist[index]
                                      .data()['price']}'),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text('date : ${mylist[index].data()['date']}'),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text('time : ${mylist[index].data()['time']}'),

                                ],
                              ),
                       ));
                      }
                  );
                }
                else if(snapshot.hasError){
                  return const Text("Error has occured in getting db data");
                }
                else{
                  return const CircularProgressIndicator();
                }
              })),

        ],
      ),
    );

  }
}

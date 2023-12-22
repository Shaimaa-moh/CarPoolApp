
import 'package:driverapp/Services/Firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';

String _selectedDate ='';

List<String> Start = ['Naser City', 'fifth settelment', 'Rehab ', 'Obour' ,'Stadium','Sheraton','Maadi','Ahram','ain shams gate 3','ain shams gate 4'];
String startLoc = Start.first;

List<String> Destination = ['fifth settelment','Naser City','Stadium','Sheraton','Maadi','Ahram','ain shams gate 3','ain shams gate 4','Rehab ', 'Obour' ,];
String destLoc = Destination.first;

List <String> tripTime=['7:30 AM','5:30 PM'];
String trip_start=tripTime.first;

String status = "accepting" ; //means the driver is available or in-service

Firestore_services _firestore =Firestore_services();
final uid = FirebaseAuth.instance.currentUser?.uid;


class OfferRide extends StatefulWidget {
  const OfferRide({super.key});

  @override
  State<OfferRide> createState() => _OfferRideState();
}
class _OfferRideState extends State<OfferRide> {

  final TextEditingController _spots = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
  super.initState();
  // Check if _selectedDate is empty, then set it to the current date
  if (_selectedDate.isEmpty) {
    DateTime currentDate = DateTime.now();
    setState(() {
      _selectedDate =
      '${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}';
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offer Ride',style: TextStyle(
          fontSize: 25,color: Colors.deepPurple
        )),
        leading: const BackButton(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
               Text('Status : $status',style: const TextStyle(
                fontSize: 20,
              )),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children :[

                const Text('Start:',style: TextStyle(
                  fontSize: 20,
                )),
                  const SizedBox(
                    width: 10,
                  ),
                  DropdownButton<String>(
                      value: startLoc,
                      items: Start.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,style: const TextStyle(
                          color: Colors.black,)),
                      );
                    }).toList(),
                    onChanged: (String? Value)  {
                      setState(() {
                        startLoc = Value!;
                      });
                    }
                  ),

                ]
              ),

              const SizedBox(
                height: 20,
              ),

              Row(
                children: [
                  const Text('Destination :',style: TextStyle(
                    fontSize: 20,
                  )),
                  const SizedBox(
                    width: 10,
                  ),
              DropdownButton<String>(
                value: destLoc,
                  items: Destination.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value , style: const TextStyle(
                            color: Colors.black,
                    )));
                  }).toList(),
                  onChanged: (String? Value)  {
                    setState(() {
                      destLoc = Value!;
                    });
                  }
              ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _spots,
                      cursorColor: Colors.deepPurple,
                          validator: (value){
                            if(value==null || value.isEmpty){
                              return "price cant be empty";

                            }
                          },
                          decoration:  const InputDecoration(
                            hintText: 'Number of spots',
                          ),
                          onChanged: (Value)  {
                            setState(() {
                              _spots.text = Value;
                            });
                      }
                        ),


              const SizedBox(
                height: 20,
              ),

              TextFormField(
                controller: _price,
                validator: (value){
                  if(value==null || value.isEmpty){
                      return "price cant be empty";

                  }
                  if (!RegExp(r'^-?[0-9]+(\.[0-9]+)?$').hasMatch(value)) {
                    return 'price number should contain only digits';
                  }
                  return null;
                },
                cursorColor: Colors.deepPurple,
                decoration: const InputDecoration(
                  hintText: 'Adjust Price',

                ),
                onChanged: (Value) {
                  setState(() {
                    _price.text = Value;
                  });
                }
              ),
                  ],
                ),
        ),


              const SizedBox(
                height: 20,
              ),

                DateTimePicker(
                  type: DateTimePickerType.date,
                  dateMask: 'd MMM, yyyy',
                  initialValue: DateTime.now().toString(),
                  icon: const Icon(Icons.event),
                  // initialValue or controller.text can be null, empty or a DateTime string otherwise it will throw an error.
                  dateLabelText: 'Select Date',
                  firstDate: DateTime(1995),
                  lastDate: DateTime.now()
                      .add(const Duration(days: 365)), // This will add one year from current date
                  validator: (value) {
                    return null;
                  },
                  onChanged: (val) async {
                    print(val);
                        setState(() {
                      _selectedDate = val; // Update the selected DateTime

                      print(_selectedDate);
                    });

                  },

                  onSaved: (val) => print(val),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    const Text('Time',style: TextStyle(
                      fontSize: 20,
                    )),
                    const SizedBox(
                      width: 15,
                    ),
                    DropdownButton <String>(items:
                      tripTime.map((String value) {
                        return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value , style: const TextStyle(
                              color: Colors.black,
                            )));}).toList(),
                        value:trip_start ,
                        onChanged: (val){
                      setState(() {
                        trip_start=val!;
                      });
                        }),
                  ],
                ),

               const SizedBox(
                height: 15,
              ),
              ElevatedButton(onPressed: () async {
                bool shouldSave = true;
                print(trip_start);
                print(startLoc);


                if (_formKey.currentState!.validate()) {
                  if (startLoc == destLoc) {
                    shouldSave = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'start and destination must not be the same'),
                      ),
                    );
                  }
                  else if ((startLoc == 'ain shams gate 4' &&
                      destLoc == 'ain shams gate 3') ||
                      (startLoc == 'ain shams gate 3' &&
                          destLoc == 'ain shams gate 4')) {
                    shouldSave = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'start and destination must not be the same'),
                      ),
                    );
                  }
                  else if (!((trip_start == '7:30 AM' &&
                      (destLoc == 'ain shams gate 3' ||
                          destLoc == 'ain shams gate 4')) ||
                      (trip_start == '5:30 PM' &&
                          (startLoc == 'ain shams gate 3' ||
                              startLoc == 'ain shams gate 4')))) {
                    shouldSave = false;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'check that correct start or destination according to trip time'),
                      ),
                    );
                  }


                  if (shouldSave) {
                    String spots = _spots.text;
                    String price = _price.text;
                    String date = _selectedDate;
                    String time = trip_start;

                    // Save ride data to Firestore
                    await _firestore.saveRideData(
                        status,
                        startLoc,
                        destLoc,
                        spots,
                        price,
                        date,
                        time,
                        uid!);
                    ScaffoldMessenger.of(context).showSnackBar(

                      const SnackBar(

                        content: Text('Ride data saved successfully!'),
                      ),
                    );
                    setState(() {
                      // Reset other variables if needed
                      _spots.clear();
                      _price.clear();
                    });
                  }
                } },child:  const Text('Save',style: TextStyle(
                                    fontSize: 20,)
              )
              )
                ],
              ),


          ),
        ),
      );

  }
}

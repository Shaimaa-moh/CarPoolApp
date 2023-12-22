import 'package:flutter/material.dart';
import 'package:project/Screens/Profile.dart';
import 'package:project/Screens/RequestTrip1.dart';

import 'RequestTrip2.dart';
List <String>options=[
   'Ride 1 ',
   'Ride 2 ',
];
String? optionValue;


class ReserveOption extends StatefulWidget {
  const ReserveOption({super.key});
  @override
  State<ReserveOption> createState() => _ReserveOptionState();
}

class _ReserveOptionState extends State<ReserveOption> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Profile(),
      appBar: AppBar(
        title: const Text('Choose Reservation Option'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade900,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: SizedBox(
                width: 350,
                child: Card(
                  elevation: 4,
                  color: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      "Ride 1",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Trip 1 is available at 7:30am, kindly reserve your trip from 10:00 pm the day before, only two destinations: Gate 3 and 4',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 350,
              child: Card(
                elevation: 4,
                color: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ExpansionTile(
                  title: Text(
                    "Ride 2",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Trip 2 is available at 5:30pm, kindly reserve your trip before 1:00 pm the same day and make sure your pickup is from the faculty of engineering campus',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(38),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const test_firestore(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Ride 1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 55,
                  ),
                  SizedBox(
                    width: 120,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const RequestTrip2(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Ride 2',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


}

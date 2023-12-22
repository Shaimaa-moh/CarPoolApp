import 'package:flutter/material.dart';
import 'package:project/Screens/DriversList.dart';
List<String> PaymentMethods = ['Cash','Visa'];
String payVal = PaymentMethods.first;

class PayVisa extends StatefulWidget {
  const PayVisa({super.key});

  @override
  State<PayVisa> createState() => _PayVisaState();
}


class _PayVisaState extends State<PayVisa> {
  //var controller = new MaskedTextController(mask: '00/00');
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade900,
          centerTitle: true,
          leading: const BackButton(),
          title: const Text('Payment details', style: TextStyle(
            fontSize: 28,
             fontFamily: 'Courier',

          ),),

        ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
           // mainAxisAlignment: MainAxisAlignment.center,
            children: [
          TextFormField(
          decoration: InputDecoration(
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10)), hintText: 'Enter your name',),),
              const SizedBox(
                height: 18,
              ),

            TextFormField(
            decoration: InputDecoration(
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            hintText: 'Enter your Phone',
            ),),
              const SizedBox(
                height: 18,
              ),

              Row(
                mainAxisAlignment:MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('Payment Method', style: TextStyle(
                      fontSize: 20,
                      color: Colors.pinkAccent,
                    ),),
                  ),

              DropdownButton(
                  value: payVal,
                  items: PaymentMethods.map((String Value) {
                    return DropdownMenuItem(
                      value: Value,
                      child: Text(Value , style: const TextStyle(
                        fontSize: 18,
                      ),),
                    );
                  }).toList(),
                  onChanged: (String? Value) {
                    setState(() {
                      payVal = Value!;
                    });
                  }),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('Card Details',style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'Courier',
                  color: Colors.white,
                ),
                ),
              ),
                const SizedBox(
                  height: 20,
                ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                 prefixIcon: const Icon(Icons.account_circle),
                  hintText: 'Card Name',
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.card_travel),
                  hintText: 'Card Number'
                ),
              ),

              const SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLength:5,
                decoration: InputDecoration(
                  hintText: 'format MM/YY',
                  suffixText: '',
                  suffixStyle: TextStyle(
                    color: Color(0xffde0486),
                  ),
                  labelText: 'Expiry Date',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                style: TextStyle(color: Colors.white),
                autofocus: true,
              ),


              const SizedBox(
              height: 15,
              ),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor: Colors.indigo,
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12)),
                         onPressed: () {
                      //_showMyDialog(context);
                           Navigator.of(context).push(
                               MaterialPageRoute(
                                 builder: (context) => const DriverList(),));
                    },

                    child: const Text("Confirm Trip",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ))),
              ),
      ],
          ),
        ),
      ),
    );
  }
}
// SizedBox(
//   height: 150,
//   child: CupertinoDatePicker(
//     mode: CupertinoDatePickerMode.date,
//     initialDateTime: DateTime(1969, 01),
//     onDateTimeChanged: (DateTime newDateTime) {
//       // Do something
//     },
//   ),
// ),

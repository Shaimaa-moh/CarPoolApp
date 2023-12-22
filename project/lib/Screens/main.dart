import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/Screens/DriversList.dart';
import 'package:project/Screens/EditProfile.dart';
import 'package:project/Screens/PayVisa.dart';
import 'package:project/Screens/Profile.dart';
import 'package:project/Screens/TripDetails.dart';
import 'OrderHistory.dart';
import 'RequestTrip2.dart';
import 'ReserveOption.dart';
import 'SignIn.dart';
import 'SignUp.dart';

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(  MaterialApp(
    //home: widget_tree(),
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.grey.shade900,
      colorScheme: const ColorScheme.dark(),
    ),
    //initialRoute: '/',
    title: "Welcome to AinShams uber",
    routes:{
       "/":(context) =>SignIn() , //landing page
       "/SignUp" :(context) =>const SignUp(),
      "/SignIn" :(context) =>const SignIn(),
      "/Profile" :(context) => Profile(),
      "/EditProfile" :(context) => EditProfile(),
      "/PayVisa" :(context) =>const PayVisa(),
      "/RequestTrip2" :(context) =>const RequestTrip2(),
      "/ReserveOption" :(context) =>const ReserveOption(),
      "/TripDetails": (context) => const TripDetails(),
      "/DriversList" :(context) =>const DriverList(),
      "/OrderHistory":(context)=> const OrderHistory(),

    },
    debugShowCheckedModeBanner: false,
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("welcome to my crazy driver app"),
        backgroundColor: Colors.indigo,

      ), // Use TripsListView here
    );
  }
}

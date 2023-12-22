import 'package:driverapp/Screens/EditProfile.dart';
import 'package:driverapp/Screens/OfferRide.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Screens/ProfilePage.dart';
import 'Screens/requestsPage.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'Screens/SignIn.dart';
import 'Screens/SignUp.dart';

Future <void> main() async  {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
    runApp( const MyApp());

  }

class MyApp extends StatelessWidget {

   const MyApp({super.key, });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
       initialRoute: '/',
        routes :{
          "/" : (context) =>  const SignIn(),//landing page
          "/SignUp" :(context) =>const SignUp(),
          "/SignIn" :(context) =>const SignIn(),
          "/OfferRide":(context)=> const OfferRide(),
          "/profile" :(context) =>  const ProfilePage(),
          "/EditProfile":(context)=> const EditProfile(),
          "/requestsPage":(context)=> const showRequests(),
        },
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
     // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: const Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

          ],
        ),
      ),

    );
  }
}


import 'package:driverapp/Services/Firestore.dart';
import 'package:driverapp/Screens/SignIn.dart';
import 'package:driverapp/Screens/requestsPage.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import '../Model/Database.dart';
import '../Services/Auth.dart';
import 'OfferRide.dart';
import 'Rides.dart';



class ProfilePage extends StatefulWidget {

  const ProfilePage({super.key,});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 0;
  final Firestore_services _firestore = Firestore_services();
  final Databasev2 db = Databasev2();
  final AuthServices _auth = AuthServices();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  List <Map> mylist = [];
  Future<void> _readingData() async {
    List<Map> response = await db.reading('''SELECT * FROM 'FILE1' ''');
    mylist = [];
    mylist.addAll(response);
    setState(() {

    });
  }

  Future <void >_writingData() async {
    Map myProfile = _firestore.fetchUserProfile() as Map;
    await db.write(
        '''INSERT INTO 'FILE1' ('UserName', 'Email', 'Phone') VALUES
             ('${myProfile['username']}',
              '${myProfile['email']}',
              '${myProfile['phone']}')''');
  }

  Future<void> _initializeProfile() async {
    await _writingData(); // Wait for writing data to complete
    final isConnected = await check(); // Check connectivity

    if (isConnected) {
      // Fetch user profile from Firestore
      _firestore.fetchUserProfile();
    } else {
      setState(() {
        _readingData(); // Read user profile from the local SQLite database

      });
      // db.checkdata();
    }
  }
  @override
void initState() {
    super.initState();
    _initializeProfile();
    _firestore.updateRideOnCondition();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [

             Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                  future: _firestore.fetchUserProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var userProfile = snapshot.data!;

                      // Render the user profile data here
                      print('User Profile Length: ${userProfile.length}');
                      return SingleChildScrollView(
                         child: Padding(
                           padding: const EdgeInsets.all(70.0),

                             child:
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                 children: [

                                     const CircleAvatar(
                                     radius: 130,
                                     backgroundImage: NetworkImage(
                                       'https://groupsorlink.com/wp-content/uploads/2021/07/1140-man-driving-a-car.imgcache.revf9c4f44f3b585ea7b920f79e4f144bd6-1024x588.jpg',
                                     ),
                                     ),
                                     IconButton(onPressed: (){
                                       Navigator.pushNamed(context, '/EditProfile',arguments: {
                                         'username': userProfile['username'],
                                         'email': userProfile['email'],
                                         'phone':userProfile['phone'],
                                         // 'carModel':userProfile['carModel'],
                                       },);
                                     }, icon:  const Icon(Icons.edit),
                                      // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditProfile()));
                                  ),

                                   ListTile(
                                  title: Column(

                                    children: [
                                      Text(' ${userProfile['username']}'),
                                    ],
                                  ),
                                  subtitle: Column(

                                    children: [
                                      Center(
                                        child: Text(
                                              ' ${userProfile['email']}'),
                                      ),
                                     Text(
                                         ' ${userProfile['phone']}'),
                                      //
                                      // Text(
                                      //     ' ${userProfile['carModel']}'),
                                    ],
                                  ),
                                   ),


                                    Padding(
                                      padding: const EdgeInsets.only(top: 245),
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width,
                                        child: BottomNavigationBar(
                                          type: BottomNavigationBarType.fixed,
                                          items: <BottomNavigationBarItem>[
                                            BottomNavigationBarItem(
                                              icon: IconButton(
                                                onPressed: () {},
                                                icon: const Icon(Icons.home),
                                              ),
                                              label: 'Home',
                                            ),
                                            BottomNavigationBarItem(
                                              icon: IconButton(
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) => const OfferRide(),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(Icons.car_rental),
                                              ),
                                              label: 'offerRides',
                                            ),
                                            BottomNavigationBarItem(
                                              icon: IconButton(
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) => const showRequests(),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(Icons.request_page),
                                              ),
                                              label: 'Requests',
                                            ),
                                            BottomNavigationBarItem(
                                              icon: IconButton(
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) => const Rides(),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(Icons.done),
                                              ),
                                              label: 'Rides',
                                            ),
                                            BottomNavigationBarItem(
                                              icon: IconButton(
                                                onPressed: () {
                                                  _auth.signOut();
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) => const SignIn(),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(Icons.logout),
                                              ),
                                              label: 'Logout',
                                            ),
                                          ],
                                          currentIndex: _selectedIndex,
                                          selectedItemColor: Colors.amber[800],
                                          onTap: _onItemTapped,
                                        ),
                                      ),
                                    ),


                                 ],
                               ),
                             ),


                          );
                    }

                    else if (snapshot.hasError) {
                      return const Text("Error has occured in getting db data");
                    }
                  else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No profile data found.'));
                  }
                    else {
                      return const CircularProgressIndicator();
                    }
                  }),
            )
            ],
        )
    );
  }
}

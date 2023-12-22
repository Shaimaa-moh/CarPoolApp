
import 'package:flutter/material.dart';
import 'package:project/Models/Firestore.dart';
import 'package:project/Screens/OrderHistory.dart';
import 'package:project/Screens/SignIn.dart';
import 'package:connectivity/connectivity.dart';
import '../Controller/Auth2.dart';
import '../Models/LocalDatabase.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {


  AuthServices _auth = AuthServices();
  final Databasev2 db = Databasev2();
  Firestore_services _firestore = Firestore_services();

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
        // db.checkdata();

      });

    }
  }

  @override
  void initState() {
    super.initState();
    _initializeProfile();

  }
  @override


  Widget build(BuildContext context) {

    return Drawer(
      //backgroundColor: Colors.deepPurple,
      child: FutureBuilder<Map<String, dynamic>>(

          future: _firestore.fetchUserProfile(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {

              var userProfile = snapshot.data!;
              return ListView(
                children:[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UserAccountsDrawerHeader(
                          accountName:  Text(' ${userProfile['username']}',style: TextStyle(
                            fontSize: 15,
                          ),),
                          accountEmail:  Text('${userProfile['email']}',style: TextStyle(
                            fontSize: 15,
                          ),),

                          currentAccountPicture: CircleAvatar(
                            child: ClipOval(
                              child: Image.network(
                                'https://th.bing.com/th/id/R.fa0ca630a6a3de8e33e03a009e406acd?rik=UOMXfynJ2FEiVw&riu=http%3a%2f%2fwww.clker.com%2fcliparts%2ff%2fa%2f0%2fc%2f1434020125875430376profile.png&ehk=73x7A%2fh2HgYZLT1q7b6vWMXl86IjYeDhub59EZ8hF14%3d&risl=&pid=ImgRaw&r=0',
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          decoration: const BoxDecoration(
                            color: Colors.black,
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://th.bing.com/th/id/R.f93c3ab2519f98ef81063811bcde9306?rik=fiqS7K74mTR4Ow&riu=http%3a%2f%2fupload.wikimedia.org%2fwikipedia%2fcommons%2f1%2f19%2fFanabe_beach_sunset.jpg&ehk=Iq8UOxiebLTHrAw3InbuBnaDbr%2bjcHvCzhsHaetONB4%3d&risl=1&pid=ImgRaw&r=0'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom:18.0, left: 15),
                            child: Text('Phone:${userProfile['phone']}',style: TextStyle(
                              fontSize: 15,
                            ),),
                          ),
                        ],
                      ),
                  IconButton(onPressed: (){
                    Navigator.pushNamed(context, '/EditProfile',arguments: {
                      'username': userProfile['username'],
                      'email': userProfile['email'],
                      'phone':userProfile['phone'],

                    },);
                  }, icon:  Icon(Icons.edit),
                    // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditProfile()));
                  ),


                  ListTile(
                      leading: const Icon(Icons.request_page),
                      title: const Text('Trip Requests'),
                      onTap: () => {
                        Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const OrderHistory(),))
                      }
                  ),
                  ListTile(
                    leading: const Icon(Icons.wallet),
                    title: const Text('Wallet'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {},
                  ),

                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Log out'),
                    onTap: () async {
                      _auth.signOut();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SignIn(),
                      ));
                      // await _auth.signOut();
                    },
                  ),
              ]
              );
            }
            else if (snapshot.hasError) {
              return Text("Error has occured in getting db data");
            }
            else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No profile data found.'));
            }
            else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}



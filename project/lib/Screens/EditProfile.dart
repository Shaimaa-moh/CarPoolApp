
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Controller/Auth2.dart';
import '../Models/Firestore.dart';
import '../Models/LocalDatabase.dart';



class EditProfile extends StatefulWidget {

  const EditProfile({super.key,});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _nameControl=TextEditingController();
  final TextEditingController _emailControl=TextEditingController();
  final TextEditingController _phoneControl=TextEditingController();
  //final TextEditingController _CarModelControl=TextEditingController();
  final Databasev2 db = Databasev2();
  Firestore_services _firestore = Firestore_services();

  @override
  Widget build(BuildContext context) {
    Map Data = ModalRoute.of(context)!.settings.arguments as Map;
    _nameControl.text = Data['username'];
    _emailControl.text = Data['email'];
    _phoneControl.text = Data['phone'];

    return  Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile',style: TextStyle(
          fontSize: 25,fontWeight: FontWeight.bold,
        ),),
        leading: const BackButton(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameControl,
                  decoration: InputDecoration(
                    hintText: 'Enter name',
                    prefixIcon: const Icon(Icons.account_circle),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _emailControl,
                  decoration: InputDecoration(
                    hintText: 'Enter email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
            TextFormField(
              controller: _phoneControl,
              decoration: InputDecoration(
                hintText: 'Enter email',
                prefixIcon: const Icon(Icons.phone_android),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
                const SizedBox(
                  height: 20,
                ),

                ElevatedButton(onPressed: () async {

                  setState(() async {
                    String username = _nameControl.text;
                    String email = _emailControl.text;
                    String phone = _phoneControl.text;
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      _firestore.saveUserData(user.uid,username,email, phone);
                      await db.write(
                            '''INSERT INTO 'FILE1' ('UserName', 'Email', 'Phone') VALUES
                       (
                        '${_nameControl.text}',
                        '${_emailControl.text},
                        '${_phoneControl.text}')''');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Data is successfully saved'),),
                      );
                    }
                  },
                  );
                },
                  child: const Text(
                    'Save ',style: TextStyle(fontSize: 20 , color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ), backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}

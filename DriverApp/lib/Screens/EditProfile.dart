import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Model/Database.dart';
import '../Services/Firestore.dart';

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
  final TextEditingController _CarModelControl=TextEditingController();
  final Databasev2 _mydb = Databasev2();
  final Firestore_services _firestore = Firestore_services();


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
                    decoration: const InputDecoration(
                      hintText: 'Enter name',
                      suffixIcon: Icon(Icons.account_circle),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _emailControl,
                    decoration: const InputDecoration(
                      hintText: 'Enter email',
                      suffixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _phoneControl,
                  decoration: const InputDecoration(
                    hintText: 'Enter phone',
                    suffixIcon: Icon(Icons.phone_android),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _CarModelControl,
                  decoration: const InputDecoration(
                    hintText: 'Enter Car Model',
                    suffixIcon: Icon(Icons.car_rental),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(onPressed: () async {

                  setState(() async {
                    String username = _nameControl.text;
                    String email =  _emailControl.text;
                    String phone =  _phoneControl.text;
                    //String carModel= _CarModelControl.text;
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {

                      _firestore.saveUserData(user.uid, username, email, phone);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Data is successfully saved'),
                        ),
                      );
                    }
                  },
                  );
                },
                   child: const Text(
                  'Save ',style: TextStyle(fontSize: 20),
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

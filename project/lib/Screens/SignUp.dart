import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/Screens/SignIn.dart';

import '../Controller/Auth2.dart';
import '../Models/Firestore.dart';


class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  //bool isLogin =false;
  Firestore_services _firestore = Firestore_services();

  AuthServices _auth = AuthServices();

  final TextEditingController _controlEmail =TextEditingController();
  final TextEditingController _controlPassword =TextEditingController();
  final TextEditingController _confirmPassword =TextEditingController();
  final TextEditingController _controlUsername =TextEditingController();
  final TextEditingController _controlPhone =TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        centerTitle: true,
      ),
      body: SingleChildScrollView(

          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key:_formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20.0),

                    child:Text("Create free Account Now", style:
                    TextStyle(
                      fontSize: 30,
                      color: Colors.indigoAccent,
                    ),),
                    ),


                     TextFormField(
                       controller: _controlUsername,
                        validator: (value) {
                        if (value == null || value.isEmpty) {
                          return ("username can't be empty");
                        }
                        else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        hintText: 'UserName',
                        prefixIcon: const Icon(Icons.account_circle),
                      ),

                    ),

                  const SizedBox(
                    height: 15,
                  ),
                    TextFormField(
                      controller: _controlPhone,
                      validator: (value){
                        if (value == null || value.isEmpty) {
                          return 'Phone cannot be empty';
                        }
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Mobile number should contain only digits';
                        }
                        if (value.length != 11) {
                          return 'Mobile number should be 11 digits';
                        }
                        return null;

                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        hintText: 'Phone',
                        prefixIcon: const Icon(Icons.phone_android),
                      ),

                    ),
                  const SizedBox(
                    height: 15,
                  ),

                   TextFormField(
                     controller: _controlEmail,
                     validator: (value) {
                       if (value == null || value.isEmpty) {
                         return ("email can't be empty");
                       }
                       if (! value.endsWith('eng.asu.edu.eg') ) {
                         return ("email must end with eng.asu.edu.eg domain");
                       }

                       else {
                         return null;
                       }
                     },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        hintText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                      ),

                    ),

                  const SizedBox(
                    height: 15,
                  ),
                    TextFormField(
                        controller: _controlPassword,
                        obscureText: true,
                        validator: (value) {
                          if (value!.length < 4 )
                            return ('Weak Password') ;
                          if (value.isEmpty) {
                            return ("Password can't be empty");
                          }
                          else {
                            return null;
                          }
                        },//to hide password
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          hintText:'Password',
                          prefixIcon: const Icon(Icons.password),
                        )
                    ),

                  const SizedBox(
                    height: 15,
                  ),
                    TextFormField(
                      controller: _confirmPassword,
                      validator: (value){
                        if (value == null || value.isEmpty){
                          return "Empty";
                        }
                        if(value != _controlPassword.text){
                          return "don't match" ;
                        }
                        return null;
                      },
                        obscureText: true, //to hide password
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          hintText:'Confirm Password',
                          prefixIcon: const Icon(Icons.password),
                        )
                    ),

                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                        ),
                        onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String email = _controlEmail.text.trim();
                          String password = _controlPassword.text.trim();
                          String username = _controlUsername.text.trim();
                          String phone = _controlPhone.text.trim();
                          try {
                            bool emailExists = await _firestore
                                .checkUserExistsInFirestore(email, password);
                            if (emailExists) {
                              // User's email already exists in Firestore, handle accordingly (show error, prompt sign-in)
                              print('Email already exists. Please sign in.');
                            }
                            else {
                              await _auth.signUpWithEmailAndPassword(
                                  email, password, username, phone);
                              User? user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                await _firestore.saveUserData(
                                    user.uid, email, username,
                                    phone); // Save user data to Firestore
                              }
                            }
                          }
                          catch (e) {
                            setState(() {
                              error = 'Sign-up error: $e';
                            });
                            print('Sign-up error: $e');
                          }
                        }},
                        child: const Text(
                          'Sign Up', style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                        )
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?",
                        style: TextStyle(
                          fontSize: 20,

                        ),
                      ),
                      TextButton(
                          onPressed :(){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context)=> const SignIn()
                              ),
                            );
                          },
                          child: const Text(
                            "Sign in",
                            style: TextStyle(fontSize: 20, color: Colors.redAccent),
                          ))
                    ],
                  )
                ],
              ),

            ),
          )
      ),
    );
  }
}

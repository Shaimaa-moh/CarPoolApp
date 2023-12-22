
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Services/Firestore.dart';
import '../Services/Auth.dart';
import 'SignIn.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final AuthServices _auth = AuthServices();
  final Firestore_services _firestore = Firestore_services();

  String email = '';
  String password = '';
  String error = '';
  //bool isLogin =false;

 // AuthServices _auth = AuthServices();

  final TextEditingController _controlEmail =TextEditingController();
  final TextEditingController _controlPassword =TextEditingController();
  final TextEditingController _controlUsername =TextEditingController();
  final TextEditingController _controlPhone =TextEditingController();
  //final TextEditingController _CarModelControl=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        leading: const BackButton(color: Colors.white,),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade900,

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
                    style: const TextStyle(color: Colors.white),
                    validator: (value){
                      if (value == null || value.isEmpty) {
                        return 'Username cannot be empty';
                      }
                      return null;
                    },
                    controller: _controlUsername,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      hintText: 'UserName',
                      hintStyle: const TextStyle(fontSize: 20.0, color: Colors.white),

                      prefixIcon: const Icon(Icons.supervised_user_circle_outlined),

                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    style: const TextStyle(color: Colors.white),

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
                      hintStyle: const TextStyle(fontSize: 20.0, color: Colors.white),

                      prefixIcon: const Icon(Icons.phone_android),
                    ),

                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  TextFormField(
                    style: const TextStyle(color: Colors.white),

                    controller: _controlEmail,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email cannot be empty';
                      }
                      else if (!value.contains('@')) {
                        return 'Enter a valid email';
                      }
                      else if (!value.endsWith('eng.asu.edu.eg')) {
                        return 'Enter a domain email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      hintText: 'Email',
                      hintStyle: const TextStyle(fontSize: 20.0, color: Colors.white),

                      prefixIcon: const Icon(Icons.email),
                    ),

                  ),

                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                      style: const TextStyle(color: Colors.white),

                      controller: _controlPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password cannot be empty';
                        } else if (value.length < 4) {
                          return 'Password must be at least 4 characters';
                        }
                        return null;
                      },
                      obscureText: true,
                      //to hide password
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        hintText:'Password',
                        hintStyle: const TextStyle(fontSize: 20.0, color: Colors.white),

                        prefixIcon: const Icon(Icons.password),
                      )
                  ),

                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: (value){
                      if (value == null || value.isEmpty) {
                      return 'Confirmation cannot be empty';
                      } else if (value != _controlPassword.text) {
                      return 'Passwords do not match';
                      }
                      return null;
                      },
                      style: const TextStyle(color: Colors.white),

                      obscureText: true, //to hide password
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        hintText:'Confirm Password',
                        hintStyle: const TextStyle(fontSize: 20.0, color: Colors.white),

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
                         // String CarModel =_CarModelControl.text.trim();

                          try {
                            bool emailExists = await _auth.checkUserExistsInFirestore(email, password);
                            if (emailExists) {
                              // User's email already exists in Firestore, handle accordingly (show error, prompt sign-in)
                              print('Email already exists. Please sign in.');
                            } else {
                              await _auth.signUpWithEmailAndPassword(email, password, username, phone);
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
                          color:Colors.white,
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

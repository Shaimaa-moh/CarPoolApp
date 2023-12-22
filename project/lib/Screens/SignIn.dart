
import 'package:flutter/material.dart';
import 'package:project/Screens/ReserveOption.dart';
import 'package:project/Screens/SignUp.dart';
import '../Controller/Auth2.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  @override
  String email = '';
  String password = '';
  String error = '';
  AuthServices _auth = AuthServices();
  final TextEditingController _controlEmail =TextEditingController();
  final TextEditingController _controlPassword =TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
     backgroundColor: Colors.grey.shade900,

      body: SingleChildScrollView(

        child:
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Form(
                 key:_formKey,
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     const Padding(
                       padding: EdgeInsets.only(top:28.0),
                       child: Text("CarPool App",style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 38,
                         color: Colors.indigoAccent,
                         fontFamily: 'Courier',
                       ) ,
                       ),
                     ),
                     const Padding(
                       padding: EdgeInsets.all(20.0),
                       child: SizedBox(
                         height: 300,
                         child: Image(
                           image:AssetImage('lib/images/driver.png'),
                         ),
                       ),
                     ),

                       TextFormField(
                        controller: _controlEmail ,
                         validator: (value){
                           if(value ==null || value.isEmpty){
                             return ("Email can't be empty");
                           }
                           else if (!value.contains('@')) {
                             return 'Enter a valid email';
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

                       Padding(
                         padding: const EdgeInsets.only(left:0,top: 12.0,right:0,bottom: 12),
                         child: TextFormField(
                           controller: _controlPassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return ("Password can't be empty");
                                }
                                else if (value.length < 4) {
                                  return 'Password must be at least 4 characters';
                                }
                                else {
                                  return null;
                                }
                              }, obscureText: true, //to hide password
                           decoration: InputDecoration(
                             border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(20)
                               ),
                               hintText:'Password',
                               prefixIcon: const Icon(Icons.password),
                             )
                           ),
                       ),

                    SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,

                          ),
                          onPressed: () async {
                          print('Entered Email: $email'); // Add this line to verify the entered email
                          if (_formKey.currentState!.validate()) {
                          String email = _controlEmail.text.trim();
                          String password = _controlPassword.text.trim();

                          try {
                          print('Checking user existence...');
                          final user = await _auth.signInWithEmailAndPassword( email,password);
                          print('Email ends with eng.asu.edu.eg: ${email.endsWith('eng.asu.edu.eg')}');

                          if(email.endsWith('eng.asu.edu.eg')&& user !=null) {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ReserveOption(),
                            ));
                          }

                          } catch (e) {
                          // Handle sign-in errors or display error messages
                          setState(() {
                          error = 'Sign-in error: $e';
                          });
                          print('Sign-in error: $e');
                          }
                          }
                            },

                          child: const Text(
                            'Sign in', style: TextStyle(
                            fontSize: 24,
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
                         const Text("Don't have account?",
                         style: TextStyle(
                           fontSize: 20,

                         ),
                         ),
                         TextButton(
                            onPressed :(){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context)=> const SignUp()
                              ),
                              );
                            },
                             child: const Text(
                               "Sign up",
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:project/Models/Firestore.dart';


class AuthServices {
  //an instance of the FirebaseAuth class
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore_services _firestore = Firestore_services();
  //Sign up with email and password
  Future<void> signUpWithEmailAndPassword(String email, String password,
      String username, String phone) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        await _firestore.saveUserData(
            user.uid, email, username, phone); // Save user data to Firestore
      }
    } catch (e) {
      print('Error during sign up: $e');
      throw e;
    }
  }

  //Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email,
      String password) async {
    try {
      UserCredential userCredential=await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    }
    catch (e) {
      print('Error during sign in: $e');
      // Handle sign-in errors here.
    }
    return null;

}

  //sign out
  Future signOut() async {
    try {
      await _auth.signOut();
      return null;
    } catch (e) {
      debugPrint("$e");
      return e;
    }
  }






//var userref = FirebaseFirestore.instance.collection('rides');
//Future<List> fetchdata()async {
//var x = await userref.get();

//List mydoc = x.docs;
//return mydoc;
//}
}

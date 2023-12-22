import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driverapp/Services/Firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';


class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth
      .instance; //an instance of the FirebaseAuth class

  final Firestore_services _firestore = Firestore_services(); //an instance of the Firestore class


  Future<bool> checkUserExistsInFirestore(String email, String password) async {
    // Ensure your Firestore query is correctly checking for user existence
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      return query.docs
          .isNotEmpty; // Returns true if there are documents matching the email
    } catch (e) {
      // Handle any potential errors during the Firestore query
      print('Error checking user existence: $e');
      return false;
    }
  }

  //Sign up with email and password
  Future<void> signUpWithEmailAndPassword(String email, String password,
      String username, String phone) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        await _firestore.saveUserData(user.uid, email, username, phone); // Save user data to Firestore
      }
    } catch (e) {
      print('Error during sign up: $e');
      rethrow;
    }
  }

  //Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email,
      String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
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

}



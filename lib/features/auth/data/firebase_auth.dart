
// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:livilon/features/auth/presentation/widgets/alertdialogue.dart';
// import 'package:livilon/features/home/presentation/screen/home_screen.dart';



class FirebaseAuthService{
 final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?>signUpwithEmailandPassword(String email,String password,BuildContext context)async{

    try {
      UserCredential credential =await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (!credential.user!.emailVerified) {
      await credential.user!.sendEmailVerification();
      // showErrorDialogue( context);
    }
      return credential.user;
      
    }on FirebaseAuthException catch (e) {
      log('Some error occurred: $e');
      return null;
    } catch (e) {
      log('Some error occurred: $e');
      
      return null;
    }
   
  }

 Future<User?>signInwithEmailandPassword(String email,String password,BuildContext context)async{

    try {
      UserCredential credential =await _auth.signInWithEmailAndPassword(email: email, password: password);
     if (!credential.user!.emailVerified) {
      Navigator.pop(context);
      log('Email not verified.');
      alertDialogue('email is not verified', context);
      return null;
    }
      return credential.user;
      
    }on FirebaseAuthException catch (e) {
      log('Some error occurred: $e');
        Navigator.pop(context); 
    showSnackBar(
              'Email is not verified.Please verify your email by register', context);
          return null;
      
    } catch (e) {
        Navigator.pop(context); 
    alertDialogue('Unexpected error occured', context); 
      log('Some error occurred: $e');
      
      return null;
    }
   
  }
void showErrorDialogue( BuildContext context) {
  Color btnClr = const Color.fromRGBO(121, 147, 174, 1);
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ),
              child: Container(
                height: 250,
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Invalid Email or Password',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'The password or email you entered is incorrect.',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Please try again.',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                        child: Text(
                      'OK',
                      style: TextStyle(color: btnClr, fontSize: 20,fontWeight: FontWeight.bold),
                    ))
                  ],
                ),
              ),
            ),
          ),
        );
      });
}
}


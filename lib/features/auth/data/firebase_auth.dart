
// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:livilon/features/home/presentation/screen/home_screen.dart';



class FirebaseAuthService{
 final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?>signUpwithEmailandPassword(String email,String password,BuildContext context)async{

    try {
      UserCredential credential =await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (!credential.user!.emailVerified) {
      await credential.user!.sendEmailVerification();
      showErrorDialogue('A verification email has been sent. Please verify your email before signing in.', context);
    }
      return credential.user;
      
    }on FirebaseAuthException catch (e) {
     showErrorDialogue(e.message??'An unknown error occured', context);
      return null;
    } catch (e) {
      log('Some error occurred: $e');
      showErrorDialogue('An unknown error occured',context);
      return null;
    }
   
  }

Future<User?> signInwithEmailandPassword(String email, String password, BuildContext context) async {
  try {
    UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    if (!credential.user!.emailVerified) {
      showErrorDialogue('Email is not verified. Please verify your email.', context);
      await _auth.signOut();
      return null;
    }

    // Navigate to the home page on success
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>const HomePage()), 
    );

    return credential.user;
  } on FirebaseAuthException catch (e) {
    if (context.mounted) {
      showErrorDialogue(e.message ?? 'An unknown error occurred', context);
    }
    return null;
  } catch (e) {
    log('Some error occurred: $e');
    if (context.mounted) {
      showErrorDialogue('An unknown error occurred', context);
    }
    return null;
  }
}
void showErrorDialogue(String message, BuildContext context) {
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


import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:livilon/features/auth/presentation/widgets/textformfield.dart';
import 'package:livilon/features/home/presentation/screen/dimension_screen.dart';
import 'package:livilon/features/home/presentation/screen/home_screen.dart';
import 'package:livilon/features/auth/data/firebase_auth.dart';
import 'package:livilon/features/auth/presentation/screen/user_login.dart';

class UserSignupScreen extends StatefulWidget {
  const UserSignupScreen({super.key});

  @override
  State<UserSignupScreen> createState() => _UserSignupScreenState();
}

class _UserSignupScreenState extends State<UserSignupScreen> {
 
  final FirebaseAuthService auth = FirebaseAuthService();

  

  final formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool obscureTextCpass=true;

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 100,
                ),
                child: Center(
                  child: Text(
                    "Let's Get Started",
                    style: TextStyle(
                        color: Colors.blue[600],
                        fontSize: 26,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Create a new account',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: CustomTextformfield(
                  keyboardType: TextInputType.name,
                    controller: usernameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Username',
                    prefixIcon: const Icon(Icons.person_outline),
                    prefixIconColor: Colors.black26),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomTextformfield(
                  keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter valid email';
                      } else if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return 'Enter a valid email';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    prefixIconColor: Colors.grey.shade400),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomTextformfield(
                    keyboardType: TextInputType.text,
                     controller: passController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please create a password';
                        } else if (value.length < 8) {
                          return 'password should be atleast 8 charecters';
                        } else if (value == '12345678') {
                          return 'please enter strong password';
                        } else {
                          return null;
                        }
                      },
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.lock_open_outlined),
                      prefixIconColor: Colors.grey.shade400,
                     obscureText: obscureText,
                      suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              obscureText=!obscureText;
                            });
                          },
                          child: obscureText
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility)))),
              const SizedBox(
                height: 15,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomTextformfield(
                    keyboardType: TextInputType.text,
                     controller: confirmPassController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'confirm your password';
                        } else if (passController.text !=
                            confirmPassController.text) {
                          return 'please re enter your password';
                        } else {
                          return null;
                        }
                      },
                      hintText: 'Confirm Password',
                      prefixIcon: const Icon(Icons.lock_open_outlined),
                      prefixIconColor: Colors.grey.shade400,
                     obscureText: obscureTextCpass,
                      suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              obscureTextCpass= !obscureTextCpass;
                            });
                          },
                          child: obscureTextCpass
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility)))),
              const SizedBox(
                height: 50,
              ),
              Container(
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), color: getButtonColor()),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        signUp();
                      }
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>const UserLoginScreen()));
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                          color: Colors.blue[400], fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void signUp() async {
    String username = usernameController.text;
    String email = emailController.text;
    String password = passController.text;

   
    User? user =
        await auth.signUpwithEmailandPassword(email, password, context);

    if (user != null) {
      await FirebaseFirestore.instance.collection("user's").doc(user.uid).set({
        'uid': user.uid,
        'username': username,
        'email': email,
        'password': password
      });

      log('user successfuly created');
      // ignore: use_build_context_synchronously
      if (mounted) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) =>const  HomePage()));
      }

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
            backgroundColor:getButtonColor(),
            content: const Text(
              'User succesfully created.',
              style: TextStyle(color: Colors.white),
            )),
      );
    } else {
      log('some error occured');
      return null;
    }
  }
}

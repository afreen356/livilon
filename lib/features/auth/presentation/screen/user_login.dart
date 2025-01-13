// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livilon/features/auth/presentation/widgets/alertdialogue.dart';
import 'package:livilon/features/auth/presentation/widgets/textformfield.dart';
import 'package:livilon/features/home/presentation/screen/dimension_screen.dart';
import 'package:livilon/features/home/presentation/screen/home_screen.dart';
import 'package:livilon/features/auth/data/firebase_auth.dart';
import 'package:livilon/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:livilon/features/auth/presentation/bloc/auth/auth_event.dart';
import 'package:livilon/features/auth/presentation/bloc/auth/auth_state.dart';
import 'package:livilon/features/auth/presentation/screen/forgot_pass.dart';
import 'package:livilon/features/auth/presentation/screen/user_signup.dart';

// ignore: must_be_immutable
class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final FirebaseAuthService auth = FirebaseAuthService();

  final formKey = GlobalKey<FormState>();
  bool obscureText = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  void initState() {
    checkLoginStatus();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  void checkLoginStatus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoadingState) {
          showDialog(
            context: context,
            // barrierDismissible: false,
            builder: (BuildContext context) {
              return const AlertDialog(
                content: SizedBox(
                  height: 90,
                  width: 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Signing in..."),
                      SizedBox(height: 20),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
            },
          );
        }
        if (state is SuccessState) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
                backgroundColor: getButtonColor(),
                content:const Text(
                  'User authenticated successfully!',
                  style: TextStyle(color: Colors.white),
                )),
          );
          Navigator.pushAndRemoveUntil(
              context,
              (MaterialPageRoute(builder: (context) => const HomePage())),
              (route) => false);
        } else if (state is UnAuthenticateState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('User not authenticated.Please login')),
          );
        } else if (state is AuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Authentication error: ${state.errorMessage} ')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 70, right: 200),
                    child: Text(
                      'Hello \nSign In!',
                      style: TextStyle(color: Colors.blue[400], fontSize: 25),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomTextformfield(
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please Enter your email';
                          } else if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                            return 'Enter a valid email';
                          } else {
                            return null;
                          }
                        },
                        controller: emailController,
                        hintText: 'your email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        prefixIconColor: Colors.grey.shade400),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomTextformfield(
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your password';
                          } else if (value.length < 8) {
                            return 'password should be atleast 8 charecters';
                          } else {
                            return null;
                          }
                        },
                        controller: passController,
                        obscureText: obscureText,
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock_open_outlined),
                        prefixIconColor: Colors.grey.shade400,
                        suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            child: obscureText
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility))),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: getButtonColor()),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            signIn();
                          }
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.only(left: 40),
                        child: Divider(thickness: 1),
                      )),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'OR',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.only(right: 40),
                        child: Divider(
                          thickness: 1,
                        ),
                      ))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 30),
                    child: GestureDetector(
                      onTap: () {
                        context.read<AuthBloc>().add(GoogleSigninEvent());
                      },
                      child: Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.black26)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              'assets/google.png',
                              height: 20,
                              width: 20,
                            ),
                            const Text(
                              'Sign in with Google',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ForgotPassPage()));
                    },
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                          color: Colors.blue[400],
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const UserSignupScreen()));
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(
                              color: Colors.blue[400],
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void signIn() async {
    String email = emailController.text;
    String password = passController.text;
    bool isSignIn = true;
    showDialog(
      context: context,

      /// Prevents closing the dialog by tapping outside
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: SizedBox(
            height: 90,
            width: 40,
            child: Column(
              children: [
                Text("Signing in..."),
                SizedBox(
                  height: 20,
                ),
                CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );

    try {
      User? user =
          await auth.signInwithEmailandPassword(email, password, context);
      if (user != null) {
        Navigator.pop(context);
        if (!user.emailVerified) {
          if (isSignIn) {
            isSignIn = false;
          }
          showSnackBar(
              'Email is not verified.Please verify your email', context);
          return;
        }

        // Successfully signed in, navigate to HomePage

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (Route<dynamic> route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          margin:const EdgeInsets.all(8),
            backgroundColor: getButtonColor(),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            content: const Text(
              'Successfully signedin',
              style: TextStyle(color: Colors.white),
            )));

        log('User signed in successfully');
      }
    } on FirebaseAuthException catch (e) {
      if (isSignIn) {
        Navigator.pop(context);
        isSignIn = false;
      }

      // Show different messages based on the error code
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found with this email. Please sign up.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password. Please try again.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is badly formatted.';
      } else {
        errorMessage = 'Sign-in failed. Please try again.';
      }
      showSnackBar(errorMessage, context);
    }
  }

  void checkUserLoginStatus() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
    }
  }
}

import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livilon/features/auth/presentation/bloc/forgetpass/forgot_pass_event.dart';
import 'package:livilon/features/auth/presentation/bloc/forgetpass/forgot_pass_state.dart';
import 'package:livilon/features/auth/presentation/bloc/forgetpass/forgot_password_bloc.dart';
import 'package:livilon/features/auth/presentation/screen/user_login.dart';
import 'package:livilon/features/auth/presentation/widgets/alertdialogue.dart';
import 'package:livilon/features/auth/presentation/widgets/textformfield.dart';


class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({super.key});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  Color btnClr = const Color.fromRGBO(121, 147, 174, 1);
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final ForgotPasswordBloc fgpasswordBloc = ForgotPasswordBloc();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
        bloc: fgpasswordBloc,
        listener: (context, state) {
          if (state is ForgotPasswordsend) {
            // Navigator.pop(context);
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const UserLoginScreen()));
            alertDialogue(
                'password reset link has been send to your email,please check your inbox',
                context);
          } else if (state is ResetLinkFailed) {
            // Navigator.of(context).pop();
            // alertDialogue('Failed to send password reset link: ${state.error}',context);
            log('reset link failed');
          }
        },
        child: Scaffold(
          body: Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Text(
                    'Recovery password',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[400],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Enter your email address.You will recieve a\n    link to create a new password via email ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CustomTextformfield(
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter valid email';
                      } else if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return 'Enter a valid email';
                      } else {
                        return null;
                      }
                    },
                    controller: emailController,
                    hintText: 'Email',
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        const Center(child:  CircularProgressIndicator());
                        resetPassword();
                        // alertDialogue(
                        //     'password reset link has been send to your email,please check your inbox',
                        //     context);
                        Future.delayed(const Duration(milliseconds: 200), () {
                          // ignore: use_build_context_synchronously
                          context
                              .read<ForgotPasswordBloc>()
                              .add(SendResetLink(emailController.text.trim()));
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        backgroundColor: btnClr),
                    child: const Text(
                      'Reset password',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ),
        ));
  }

  Future<void> resetPassword() async {
    final email = emailController.text.trim();
    if (email.isNotEmpty) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text('Password reset email sent. Please check your inbox.')));
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const UserLoginScreen()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'password failed to send  ${e.toString()}',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  void showLoadingDialogue() {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

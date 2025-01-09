import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {}
class AuthInitial extends AuthState{}
class AuthLoadingState extends AuthState{}
class SuccessState extends AuthState{
  User? user;
  String? username;
  String? email;
  SuccessState({this.user,this.username,this.email});
}
 class UnAuthenticateState extends AuthState{}
class AuthErrorState extends AuthState{ 
  final String errorMessage;
  AuthErrorState({required this.errorMessage});
}
 
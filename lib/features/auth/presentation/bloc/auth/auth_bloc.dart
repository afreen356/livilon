import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:livilon/features/auth/presentation/bloc/auth/auth_event.dart';
import 'package:livilon/features/auth/presentation/bloc/auth/auth_state.dart';

class AuthBloc extends Bloc<Authevent, AuthState> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn gsignIn = GoogleSignIn();

  AuthBloc() : super(AuthInitial()) {
    on<GoogleSigninEvent>((event, emit) => googleSignInEvent(event, emit));
  }

  Future<void> googleSignInEvent(
      GoogleSigninEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      // begin signIn process
      final GoogleSignInAccount? gUser = await gsignIn.signIn();
      if (gUser != null) {
        // retrieve authToken
        final GoogleSignInAuthentication gAuth = await gUser.authentication;
        // creates firebase credential
        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: gAuth.accessToken, idToken: gAuth.idToken);
        // use to signin with firebase
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);
        //retrieves the user which holds the details authenticated firebase user
        final user = userCredential.user;

        if (user != null) {
          final userName = user.displayName;
          final email = user.email;

          final userDoc =
              FirebaseFirestore.instance.collection("user's").doc(user.uid);
          final docSnapshot = await userDoc.get();
          if (!docSnapshot.exists) {
            await userDoc.set({
              'uid': user.uid,
              'email': email,
              'username': userName,
              'createdAt': DateTime.now()
            });
            log('User details saved to Firestore.');
          } else {
            log('user already exists');
          }
          emit(SuccessState(username: userName, email: email));
        } else {
          log('google signin failed');
          emit(UnAuthenticateState());
        }
      }
    } catch (e) {
      emit(AuthErrorState(errorMessage: e.toString()));
    }
  }
}

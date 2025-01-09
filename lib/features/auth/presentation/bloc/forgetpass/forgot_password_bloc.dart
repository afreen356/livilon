import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:livilon/features/auth/presentation/bloc/forgetpass/forgot_pass_event.dart';
import 'package:livilon/features/auth/presentation/bloc/forgetpass/forgot_pass_state.dart';


class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent,ForgotPasswordState>{
    ForgotPasswordBloc() :super (ForgotPasswordInitial()){
      on<ForgotPasswordEvent>((event,emit){});
     on<SendResetLink>((event, emit) {
       try {
         sendPasswordResetEmail(event.email);
         emit(ForgotPasswordsend());

         
       } catch (e) {
         emit(ResetLinkFailed(e.toString()));
       }
     },);
    }
    Future<void> sendPasswordResetEmail(String email)async{
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      } catch (e) {
        if(e is FirebaseAuthException){
          switch (e.code){
            case'user not found':
            break;
            case 'invalid email':
            break;
            default:
          }
        }
      }
    }

    
}

abstract class  ForgotPasswordEvent {}
  
class SendResetLink extends ForgotPasswordEvent{
  
   final String email;

   SendResetLink(this.email);
}
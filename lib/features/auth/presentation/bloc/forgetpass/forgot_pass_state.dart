abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState{

}

class ForgotPasswordsend extends ForgotPasswordState{}

class ResetLinkFailed extends ForgotPasswordState{
  final String error;
  ResetLinkFailed(this.error);
}
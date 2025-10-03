abstract class LoginState {}

class LoginInitial extends LoginState {}

class OnLoading extends LoginState{}

class OnSuccess extends LoginState {
  final String userId;

  OnSuccess(this.userId);
}

class OnFailure extends LoginState {
  final String error;

  OnFailure(this.error);
}

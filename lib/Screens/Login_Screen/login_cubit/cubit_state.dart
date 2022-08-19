abstract class LoginCubitstate{}
class InitialState extends LoginCubitstate {}
class LoginLoadingState extends InitialState {}
class LoginSuccessState extends InitialState 
{
  final  uId;
  LoginSuccessState(this.uId);
}
class LoginErrorState extends InitialState 
{
  final  error;
  LoginErrorState(this.error);
}


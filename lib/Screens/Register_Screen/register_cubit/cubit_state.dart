abstract class RegisterCubitstate{}
class InitialState extends RegisterCubitstate {}

class RegisterLoadingState extends InitialState {}
class RegisterSuccessState extends InitialState {}
class RegisterErrorState extends InitialState 
{
  final error;
  RegisterErrorState(this.error);
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/Screens/Register_Screen/register_cubit/cubit_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/users_model/users_model.dart';

class RegisterCubit extends Cubit<InitialState> {
  RegisterCubit() : super(InitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    required String email,
    required String password,
    required String fristName,
    required String lastName,
    required String phone,
  }) {
    emit(RegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print('Register Done');
      userDataCreate(
          uId: value.user!.uid,
          email: email,
          password: password,
          fristName: fristName,
          bio: 'bio',
          lastName: lastName,
          phone: phone,
          cover: 'https://img.freepik.com/free-photo/vegetables-from-basket-wooden-table_155003-5607.jpg?w=1060&t=st=1660922319~exp=1660922919~hmac=5a581227f4f9f9c761963ac2a66dba4f40775381601a83bddd9d25ae8baa8f57',
          image:
              'https://img.freepik.com/free-photo/waist-up-portrait-handsome-serious-unshaven-male-keeps-hands-together-dressed-dark-blue-shirt-has-talk-with-interlocutor-stands-against-white-wall-self-confident-man-freelancer_273609-16320.jpg?w=1060&t=st=1660917848~exp=1660918448~hmac=93394f57945d2f22ffdcf1b1a0432556cf88d51cd2d8607702033fb93bd22390');
    }).catchError((error) {
      print('Error In userRegister');
      emit(RegisterErrorState(error));
    });
  }

  void userDataCreate({
    required String email,
    required String password,
    required String fristName,
    required String lastName,
    required String phone,
    required String uId,
    required String image,
    required String cover,
    required String bio,
  }) {
    // take instance from class UserModel To Send From toMap Function
    UserModel userData = UserModel(
      isVerify: false,
      email: email,
      uId: uId,
      fristName: fristName,
      bio: bio,
      password: password,
      phone: phone,
      image: image,
      cover: cover
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(userData.toMap())
        .then(
            (value) //Create collection users and save user data in user collection
            {
      print('Register Done');
      emit(RegisterSuccessState());
    }).catchError((error) {
      print('Error In userRegister');
      emit(RegisterErrorState(error));
    });
  }
}

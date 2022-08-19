import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/Constance/constance.dart';
import 'package:firebase_app/Screens/layout_screen/layout_cubit/cubit_state.dart';
import 'package:firebase_app/Screens/layout_screen/screens/chats/chats.dart';
import 'package:firebase_app/Screens/layout_screen/screens/feeds/feeds.dart';
import 'package:firebase_app/Screens/layout_screen/screens/users/users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../model/users_model/users_model.dart';
import '../screens/posts/post.dart';
import '../screens/settings/settings.dart';

class LayoutCubit extends Cubit<InitialState> {
  LayoutCubit() : super(InitialState());

  static LayoutCubit get(context) => BlocProvider.of(context);
  UserModel? model;
  void getUserData() {
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      emit(LayoutLoadingState());
      model = UserModel.fromJson(value.data()!);
      print(model!.fristName);
      emit(LayoutSuccessState());
    }).catchError((error) {
      print('Error In Get Data User ${error.toString()}');
      emit(LayoutErrorState(error));
    });
  }

  int currentIndex = 0;
  void changeNav(int index) {
    currentIndex = index;
    emit(ChangeNav());
  }

  List<Widget> screens = [
    Feeds(),
    Chats(),
    Posts(),
    Users(),
    SettingsScreen(),
  ];
}

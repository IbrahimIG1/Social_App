import 'package:firebase_app/Constance/constance.dart';
import 'package:firebase_app/Screens/layout_screen/layout_cubit/layout_cubit.dart';
import 'package:firebase_app/Screens/layout_screen/layout_screen.dart';
import 'package:firebase_app/shared/shared_prefrence/shared_prefrence.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Screens/Login_Screen/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();
  await Firebase.initializeApp();
  uId = SharedPrefs.getData(key: 'uId') ?? null;
  Widget? startWidget;
  if (uId != null) {
    startWidget = LayoutScreen();
  } else
    (startWidget = LoginScreen());
  runApp(MyApp(startWidget));
}

class MyApp extends StatelessWidget {
  MyApp(this.startWidget);

  // This widget is the root of your application.
  Widget? startWidget;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        
        BlocProvider(create:(context)=>LayoutCubit()..getUserData() ,),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white
        ),
        home: startWidget,
      ),
    );
  }
}

import 'package:firebase_app/Constance/constance.dart';
import 'package:firebase_app/Screens/layout_screen/layout_cubit/layout_cubit.dart';
import 'package:firebase_app/Screens/layout_screen/layout_screen.dart';
import 'package:firebase_app/shared/flutter_toast/flutter_toast.dart';
import 'package:firebase_app/shared/shared_prefrence/shared_prefrence.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Screens/Login_Screen/login.dart';


// void get notification when app in backround
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  showToast(txt: 'on Background Message', color: Colors.green);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();
  await Firebase.initializeApp();
  var token = await FirebaseMessaging.instance.getToken();
print(token);
// void get notification when app open
  FirebaseMessaging.onMessage.listen((event) {
    print(event.data.toString());
    showToast(txt: 'on Message', color: Colors.green);
  });
// void get notification when app open with click on notification
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.data.toString());
    showToast(txt: 'on Message Opened App', color: Colors.green);
  });
// void get notification when app in backround "firebaseMessagingBackgroundHandler"
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
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
        BlocProvider(
          create: (context) => LayoutCubit()
            ..getUserData()
            ..getPosts()
            ..getAllUsers(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            appBarTheme: AppBarTheme(
                elevation: 0,
                backgroundColor: Colors.white,
                titleTextStyle: TextStyle(color: Colors.black),
                iconTheme: IconThemeData(color: Colors.black)),
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.white),
        home: startWidget,
      ),
    );
  }
}

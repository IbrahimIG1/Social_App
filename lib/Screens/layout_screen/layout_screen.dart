import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_app/Screens/layout_screen/layout_cubit/cubit_state.dart';
import 'package:firebase_app/Screens/layout_screen/layout_cubit/layout_cubit.dart';
import 'package:firebase_app/shared/flutter_toast/flutter_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutCubitstate>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = LayoutCubit.get(context);
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  cubit.appBarTitle[cubit.currentIndex]
                  ,
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.white,
                elevation: 0,
              ),
              body: cubit.screens[cubit.currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.changeNav(index);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.chat_outlined),
                    label: 'Chats',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.post_add_rounded),
                    label: 'Posts',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.supervised_user_circle_sharp),
                    label: 'Users',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: 'Settings',
                  ),
                ],
                type: BottomNavigationBarType.fixed,
              ));
        });
  }

  Widget _verifyBox(LayoutCubit cubit) => Column(
        children: [
          if (!cubit.model!.isVerify!)
            Container(
              color: Colors.amber,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Icon(Icons.info_outline),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                        child: Text(
                      'Please verfiy your Email',
                    )),
                    SizedBox(
                      width: 20,
                    ),
                    TextButton(
                        onPressed: () {
                          FirebaseAuth.instance.currentUser!
                              .sendEmailVerification()
                              .then((value) {
                            showToast(
                                txt: 'Cheak Your Mail', color: Colors.green);
                          }).catchError((error) {
                            print(
                                'error in Verfication => ${error.toString()}');
                          });
                        },
                        child: Text('SEND'))
                  ],
                ),
              ),
            ),
        ],
      );
}

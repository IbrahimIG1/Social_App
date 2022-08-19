import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_app/Screens/Login_Screen/login_cubit/login_cubit.dart';
import 'package:firebase_app/Screens/Register_Screen/register.dart';
import 'package:firebase_app/Screens/layout_screen/layout_screen.dart';
import 'package:firebase_app/shared/buttons/buttons.dart';
import 'package:firebase_app/shared/flutter_toast/flutter_toast.dart';
import 'package:firebase_app/shared/sizedbox/sizedbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/clipper_shape_login/clipper.dart';
import '../../shared/navigators/navigators.dart';
import '../../shared/shared_prefrence/shared_prefrence.dart';
import '../../shared/textformfield/textformfiled.dart';
import 'login_cubit/cubit_state.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginCubitstate>(
        listener: (context, state) 
        {
           if(state is LoginErrorState)
            {
              showToast(txt: (state.error!.toString()), color: Colors.red);
            }
          if(state is LoginSuccessState)
            {
              showToast(txt: 'Login Done', color: Colors.green);
              SharedPrefs.saveData(value: state.uId, key: 'uId');
               NavigateAndReplace(context, LayoutScreen());
            } 
           
        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipperShape(txt: 'Login'),
                      defaultSizeBox(),
                      defaultFormField(
                        controller: emailController,
                        validat: (String value) {
                          if (value.isEmpty) {
                            return 'This Field Must\'n be Empty';
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        lable: 'Email',
                        prefix: Icons.email,
                      ),
                      defaultSizeBox(),
                      defaultFormField(
                        controller: passwordController,
                        validat: (String value) {
                          if (value.isEmpty) {
                            return 'This Field Must\'n be Empty';
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        lable: 'Password',
                        prefix: Icons.email,
                      ),
                      defaultSizeBox(),
                      ConditionalBuilder(
                        condition: state is! LoginLoadingState,
                        fallback: (context) => Center(child: CircularProgressIndicator(),),
                        builder: (context) {
                          return defaultButton(
                            context: context,
                            txt: 'Sign In',
                            iconty: Icons.door_front_door_outlined,
                            onTap: () {
                              if (formKey.currentState!.validate())
                                cubit.userLogin(
                                    email: emailController.text,
                                    password: passwordController.text);
                            },
                            
                          );
                        }
                      ),
                      defaultSizeBox(),
                      InkWell(
                          onTap: () {
                            NavigateTo(context, RegisterScreen());
                          },
                          child: Text(
                            'i don\'t have account ?',
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          ))
                    ],
                  )),
            ),
          );
        },
      ),
    );
  }
}

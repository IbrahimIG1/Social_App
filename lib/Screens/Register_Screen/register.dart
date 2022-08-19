import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_app/Screens/Register_Screen/register_cubit/cubit_state.dart';
import 'package:firebase_app/Screens/Register_Screen/register_cubit/register_cubit.dart';
import 'package:firebase_app/shared/flutter_toast/flutter_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/buttons/buttons.dart';
import '../../shared/clipper_shape_login/clipper.dart';
import '../../shared/sizedbox/sizedbox.dart';
import '../../shared/textformfield/textformfiled.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  var formKey = GlobalKey<FormState>();

  var firstNameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var adressController = TextEditingController();
  var passwordController = TextEditingController();
  var lastnameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterCubitstate>(
          listener: (context, state) {
        if (state is RegisterErrorState) {
          showToast(txt: (state.error!.toString()), color: Colors.red);
        }
        if (state is RegisterSuccessState) {
          showToast(txt: 'Register Done', color: Colors.green);
          Navigator.pop(context);
        }
      }, builder: (context, state) {
        var cubit = RegisterCubit.get(context);
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
                    ClipperShape(txt: 'Register'),
                    defaultSizeBox(),
                    defaultFormField(
                      controller: firstNameController,
                      validat: (String value) {
                        if (value.isEmpty) {
                          return 'This Field Must\'n be Empty';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.name,
                      lable: 'first name',
                    ),
                    defaultSizeBox(),
                    defaultFormField(
                      controller: lastnameController,
                      validat: (String value) {
                        if (value.isEmpty) {
                          return 'This Field Must\'n be Empty';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.name,
                      lable: 'last name',
                    ),
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
                        lable: 'email',
                        prefix: Icons.email),
                    defaultSizeBox(),
                    defaultFormField(
                      controller: phoneController,
                      validat: (String value) {
                        if (value.isEmpty) {
                          return 'This Field Must\'n be Empty';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.number,
                      lable: 'phone',
                      prefix: Icons.phone,
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
                      lable: 're-password',
                    ),
                    defaultSizeBox(),
                    ConditionalBuilder(
                      condition: state is! RegisterLoadingState,
                      fallback: (context) => Center(child: CircularProgressIndicator(),),
                      builder: (context) {
                        return defaultButton(
                          context: context,
                          txt: 'Register',
                          iconty: Icons.door_front_door_outlined,
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              cubit.userRegister(
                                email: emailController.text,
                                password: passwordController.text,
                                fristName: firstNameController.text,
                                lastName: lastnameController.text,
                                phone: phoneController.text,
                              );
                            }
                          },
                        );
                      }
                    ),
                  ],
                )),
          ),
        );
      }),
    );
  }
}

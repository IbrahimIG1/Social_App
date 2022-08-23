import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_app/Screens/layout_screen/layout_cubit/cubit_state.dart';
import 'package:firebase_app/Screens/layout_screen/layout_cubit/layout_cubit.dart';
import 'package:firebase_app/Screens/layout_screen/screens/chats/chat_details.dart';
import 'package:firebase_app/model/users_model/users_model.dart';
import 'package:firebase_app/shared/navigators/navigators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Chats extends StatelessWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutCubitState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = LayoutCubit.get(context);
        return ConditionalBuilder(
            condition: cubit.users.length > 0,
            fallback: (context) => Center(
                  child: CircularProgressIndicator(),
                ),
            builder: (context) {
              return ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return chatsItems(cubit.users[index],context);
                  },
                  separatorBuilder: (context, index) => Divider(
                        color: Colors.grey,
                      ),
                  itemCount: cubit.users.length);
            });
      },
    );
  }

  Widget chatsItems(
    UserModel model,
    context
  ) =>
      InkWell(
        onTap: () 
        {
          NavigateTo(context, ChatDetails(model: model,));
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage("${model.image!}"),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        model.fristName!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              )),
            ],
          ),
        ),
      );
}

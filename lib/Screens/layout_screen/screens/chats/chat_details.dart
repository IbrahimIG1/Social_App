import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_app/Screens/layout_screen/layout_cubit/cubit_state.dart';
import 'package:firebase_app/Screens/layout_screen/layout_cubit/layout_cubit.dart';
import 'package:firebase_app/model/chat_model/chat_model.dart';
import 'package:firebase_app/model/users_model/users_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatDetails extends StatelessWidget {
  UserModel model;
  ChatDetails({required this.model});
  var messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      LayoutCubit.get(context). getMessage(receverId: model.uId!);
      return BlocConsumer<LayoutCubit, LayoutCubitState>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = LayoutCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                  title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage('${model.image}'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(model.fristName!),
                ],
              )),
              body: Column(
                children: [
                  Expanded(
                    child: ConditionalBuilder(
                        condition: cubit.messages.length > 0,
                        fallback: (context) => Center(
                              child: CircularProgressIndicator(),
                            ),
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListView.separated(
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        var messageList = cubit.messages[index];
                                        if (cubit.model!.uId! ==
                                            messageList.senderId) {
                                          return message(
                                              color: Colors.blue[200]!,
                                              topEnd: 0,
                                              topStart: 10,
                                              message: messageList,
                                              align: AlignmentDirectional
                                                  .centerEnd);
                                        } else {
                                          return message(
                                              color: Colors.grey[300]!,
                                              topEnd: 10,
                                              topStart: 0,
                                              message: messageList,
                                              align: AlignmentDirectional
                                                  .centerStart);
                                        }
                                      },
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                            height: 5,
                                          ),
                                      itemCount: cubit.messages.length),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                  Column(
                    children: [
                      if (cubit.messageImageFile != null)
                        Container(
                          width: 100,
                          height: 120,
                          child: Stack(
                            alignment: Alignment.topLeft,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                image: FileImage(cubit.messageImageFile!),
                              ))),
                              IconButton(
                                  onPressed: () 
                                  {
                                    cubit.closedMessageImage();
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  )),
                            ],
                          ),
                        ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border:
                                Border.all(color: Colors.grey[300]!, width: 1)),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: messageController,
                                decoration: InputDecoration(
                                    hintText: 'Type Your Message here ...',
                                    border: InputBorder.none),
                              ),
                            ),
                            sendMessageButton(cubit),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          });
    });
  }

  Widget message(
          {required Color color,
          required double topStart,
          required double topEnd,
          required ChatModel message,
          required AlignmentGeometry align}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Align(
            alignment: align,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(topStart),
                  topEnd: Radius.circular(topEnd),
                  bottomEnd: Radius.circular(10),
                  bottomStart: Radius.circular(10),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(message.text!),
            ),
          ),
          if (message.image != '')
            Container(
                width: 150,
                height: 220,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: NetworkImage(message.image!),
                )))
        ],
      );

  Widget sendMessageButton(LayoutCubit cubit) => Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
              onPressed: () {
                cubit.getMessageImage();
              },
              icon: Icon(Icons.photo)),
          Container(
            height: 50,
            width: 60,
            child: MaterialButton(
              onPressed: () {
                cubit.sentMessage(
                    dateTime: DateTime.now().toString(),
                    receverId: model.uId!,
                    text: messageController.text,
                    image: cubit.messageImageUrl != ''
                        ? cubit.messageImageUrl
                        : '');
                messageController.text = '';
                cubit.messageImageFile == null;
              },
              child: Icon(
                Icons.send_sharp,
                color: Colors.white,
              ),
              color: Colors.blue,
            ),
          ),
        ],
      );
}

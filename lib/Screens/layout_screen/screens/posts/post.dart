import 'package:firebase_app/Screens/layout_screen/layout_cubit/cubit_state.dart';
import 'package:firebase_app/Screens/layout_screen/layout_cubit/layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Posts extends StatelessWidget {
  Posts({Key? key}) : super(key: key);
  var textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutCubitstate>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = LayoutCubit.get(context);
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(children: [
                if (state is CreatePostLoadingState) LinearProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                postUserImageAndName(cubit),
                Expanded(
                  child: TextFormField(
                      controller: textController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'what is in your mind... ')),
                ),
                if (cubit.postImageFile != null)
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        height: 500,
                        child: Card(
                          child: Image(
                            image: FileImage(cubit.postImageFile!)
                                as ImageProvider,
                            fit: BoxFit.cover,
                            height: 200,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          cubit.closedPostImage();
                        },
                        icon: CircleAvatar(child: Icon(Icons.close)),
                      ),
                    ],
                  ),
                addPhotoInPost(cubit),
              ]),
            ),
          );
        });
  }

  //  user Information when posted
  Widget postUserImageAndName(LayoutCubit cubit) => Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage("${cubit.model!.image}"),
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            'Ibrahim Elgammal',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),Spacer(),
          MaterialButton(
            color: Colors.blue,
            onPressed: () {
              if (cubit.postImageFile == null) {
                cubit.createPost(
                  text: textController.text,
                  dateTime: DateTime.now().toString(),
                );
              } else {
                cubit.uploadPostImage(text: textController.text);
              }
            },
            child: Text(
              'Post',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          )
        ],
      );

  // Buttons to add photo in post
  Widget addPhotoInPost(LayoutCubit cubit) => Row(
        children: [
          Expanded(
              child: TextButton(
                  onPressed: () {
                    cubit.getPostImage();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_outlined),
                      SizedBox(
                        width: 10,
                      ),
                      Text('add photo'),
                    ],
                  ))),
          Expanded(
            child: TextButton(
              onPressed: () {},
              child: Text('# Tags'),
            ),
          ),
        ],
      );
}

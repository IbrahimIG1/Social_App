import 'package:firebase_app/Screens/layout_screen/layout_cubit/cubit_state.dart';
import 'package:firebase_app/Screens/layout_screen/layout_cubit/layout_cubit.dart';
import 'package:firebase_app/shared/buttons/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/users_model/users_model.dart';

class Posts extends StatelessWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutCubitstate>(
        listener: ((context, state) {}),
        builder: (context, state) {
          var model = LayoutCubit.get(context).model;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                imagesProfile(context, model!),
                Text(
                  '${model.fristName!}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 20),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'bio ...',
                  style: Theme.of(context).textTheme.caption,
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    postDetails(context, 'posts', '50'),
                    postDetails(context, 'likes', '290'),
                    postDetails(context, 'followers', "136k"),
                    postDetails(context, 'comments', '70'),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                editProfileButtons(),
              ],
            ),
          );
        });
  }
  //  Posts And Followers Details
  Widget postDetails(context, String txt, String num) => Expanded(
        child: Column(
          children: [
            Text(
              num,
              style: Theme.of(context).textTheme.subtitle2,
            ),
            Text(
              txt,
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      );
  // Profiles Images > Cover Image > Person Image 
  Widget imagesProfile(context, UserModel model) => Container(
        height: 190,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 140,
                child: Card(
                  child: Image(
                    image: NetworkImage(
                      '${model.cover}',
                    ),
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            CircleAvatar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              radius: 64,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                  "${model.image!}",
                ),
              ),
            ),
          ],
        ),
      );
  // Edit Profile Button 
  Widget editProfileButtons()=>Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    OutlinedButton(onPressed: () {}, child: Icon(Icons.edit)),
                  ],
                );
}

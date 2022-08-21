import 'package:firebase_app/Screens/layout_screen/layout_cubit/layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout_cubit/cubit_state.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutCubitstate>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = LayoutCubit.get(context);
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: EdgeInsets.all(8),
                  elevation: 10,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: const [
                      Image(
                        image: NetworkImage(
                          'https://as1.ftcdn.net/v2/jpg/03/18/03/94/1000_F_318039459_xlrsQ9eNZ5rNtnqpyQ2lDqipQDdo52fs.jpg',
                        ),
                        fit: BoxFit.cover,
                        height: 200,
                        width: double.infinity,
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'communication with Freinds',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                if(cubit.model != null)
                ListView.separated(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return postCard(context, cubit);
                    },
                    separatorBuilder: (context, index) => SizedBox(
                          height: 8,
                        ),
                    itemCount: 10),
                SizedBox(
                  height: 8,
                )
              ],
            ),
          );
        });
  }
  // user Post with image and text
  Widget postCard(context, LayoutCubit cubit) => Card(
        elevation: 5,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            avatarAndName(context, cubit),
            Divider(
              color: Colors.grey,
            ),
            Text(
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum',
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(height: 1.3, fontWeight: FontWeight.w500),
            ),
            Container(
                height: 25,
                child: MaterialButton(
                  onPressed: () {},
                  child: Text(
                    '#softwar #softwar #softwar #softwar',
                    style: TextStyle(color: Colors.blue),
                  ),
                )),
            postImag(),
            likeAndComment(),
            Divider(
              color: Colors.grey,
            ),
            WriteAComment(context,cubit),
          ]),
        ),
      );
  // persone Circle Picture , Name , Verify Mark
  Widget avatarAndName(context, LayoutCubit cubit) => Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
                 "${cubit.model!.image}"
             ),   ),
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
                    'Ibrahim Elgammal',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Icon(
                    Icons.verified,
                    color: Colors.blue,
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text('30 Jan , 2022 at 11:20 pm',
                  style: Theme.of(context).textTheme.caption),
            ],
          )),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz))
        ],
      );
  // Post Picture
  Widget postImag() => Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  'https://as1.ftcdn.net/v2/jpg/03/18/03/94/1000_F_318039459_xlrsQ9eNZ5rNtnqpyQ2lDqipQDdo52fs.jpg')),
        ),
      );
  // Row Have Number Of Likes , Comments
  Widget likeAndComment() => Row(
        children: [
          Expanded(
            child: InkWell(
              child: Row(children: [
                Icon(Icons.heart_broken, color: Colors.red),
                SizedBox(
                  width: 5,
                ),
                Text('120'),
              ]),
            ),
          ),
          Spacer(),
          Expanded(
            child: InkWell(
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Icon(
                  Icons.comment,
                  color: Colors.blueGrey,
                ),
                SizedBox(
                  width: 5,
                ),
                Text('120'),
              ]),
            ),
          ),
        ],
      );
  // Row Where Write A comment
  Widget WriteAComment(context,LayoutCubit cubit) => Row(children: [
        CircleAvatar(
          radius: 15,
          backgroundImage: NetworkImage(
            "${cubit.model!.image}"
            //'https://img.freepik.com/free-photo/satisfied-bearded-male-youngster-listens-merry-song-headphones-moves-pink-background-boosts-mood-with-cool-music-feels-upbeat-wears-red-hat-black-t-shirt_273609-34632.jpg',
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          'write comment...',
          style: Theme.of(context).textTheme.caption,
        ),
        Spacer(),
        Row(children: [
          Icon(
            Icons.heart_broken,
            color: Colors.red,
          ),
          SizedBox(
            width: 5,
          ),
          Text('like'),
        ]),
      ]);
}

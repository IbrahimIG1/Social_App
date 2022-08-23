import 'package:firebase_app/Screens/layout_screen/layout_cubit/cubit_state.dart';
import 'package:firebase_app/Screens/layout_screen/layout_cubit/layout_cubit.dart';
import 'package:firebase_app/model/users_model/users_model.dart';
import 'package:firebase_app/shared/textformfield/textformfiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditUserInfo extends StatelessWidget {
  EditUserInfo({Key? key}) : super(key: key);
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var bioController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutCubitState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = LayoutCubit.get(context);
          var model = cubit.model;
          var pickerImageProfile = cubit.profileImageFile;
          var pickerImageCover = cubit.coverImageFile;
          nameController.text = cubit.model!.fristName!;
          phoneController.text = cubit.model!.phone!;
          bioController.text = cubit.model!.bio!;
          return Scaffold(
              appBar: AppBar(
                actions: [
                  MaterialButton(
                      onPressed: () {
                        cubit.updateUserData(
                          coverImage: model!.cover!,
                          profileImage: model.image!,
                          email: model.email!,
                          bio: bioController.text,
                          fristName: nameController.text,
                          phone: phoneController.text,
                        );
                      },
                      child: Text('Update'))
                ],
                title: Text(
                  'Edite',
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    if(state is UpdateUsersDataLoadingState)
                    LinearProgressIndicator(),
                    
                    imagesProfileEdit(context, model!, cubit,
                        pickerImageProfile, pickerImageCover),
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
                      '${model.bio!}',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    defaultFormField(
                      controller: nameController,
                      validat: () {},
                      keyboardType: TextInputType.name,
                      lable: 'Name',
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    defaultFormField(
                      controller: bioController,
                      validat: () {},
                      keyboardType: TextInputType.name,
                      lable: 'Bio',
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    defaultFormField(
                      controller: phoneController,
                      validat: () {},
                      keyboardType: TextInputType.phone,
                      lable: 'Phone',
                    ),
                  ],
                ),
              ));
        });
  }

  Widget imagesProfileEdit(context, UserModel model, LayoutCubit cubit,
          imagePicker, coverPicker) =>
      Container(
        height: 190,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    height: 140,
                    child: Card(
                      child: Image(
                        image: coverPicker == null
                            ? NetworkImage(
                                '${model.cover}',
                              )
                            : FileImage(coverPicker) as ImageProvider,
                        fit: BoxFit.cover,
                        height: 200,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      cubit.getCoverImage();
                    },
                    icon: CircleAvatar(child: Icon(Icons.camera_alt_outlined)),
                  ),
                ],
              ),
            ),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  radius: 64,
                  child: CircleAvatar(
                      radius: 60,
                      backgroundImage: imagePicker == null
                          ? NetworkImage(
                              "${model.image!}",
                            )
                          : FileImage(imagePicker) as ImageProvider),
                ),
                IconButton(
                  onPressed: () {
                    cubit.getProfileImage();
                  },
                  icon: CircleAvatar(child: Icon(Icons.camera_alt_outlined)),
                ),
              ],
            ),
          ],
        ),
      );
}

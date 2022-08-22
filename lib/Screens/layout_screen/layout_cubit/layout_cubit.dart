import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/Constance/constance.dart';
import 'package:firebase_app/Screens/layout_screen/layout_cubit/cubit_state.dart';
import 'package:firebase_app/Screens/layout_screen/screens/chats/chats.dart';
import 'package:firebase_app/Screens/layout_screen/screens/users/users.dart';
import 'package:firebase_app/model/post_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../model/users_model/users_model.dart';
import '../screens/home/home.dart';
import '../screens/posts/post.dart';
import '../screens/settings/settings.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class LayoutCubit extends Cubit<InitialState> {
  LayoutCubit() : super(InitialState());

  static LayoutCubit get(context) => BlocProvider.of(context);
  UserModel? model;
  PostModel? postModel;


  void getUserData() {
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      emit(LayoutLoadingState());
      model = UserModel.fromJson(value.data()!);
      print(model!.fristName);
      print('Get Data Done');
      emit(LayoutSuccessState());
    }).catchError((error) {
      print('Error In Get Data User ${error.toString()}');
      emit(LayoutErrorState(error));
    });
  }

  int currentIndex = 0;
  void changeNav(int index) {
    currentIndex = index;
    // if (currentIndex == 2) {
    //   emit(PostScreenState());
    // }
    emit(ChangeNav());
  }

// List To Change NavBar Screen
  List<Widget> screens = [
    Home(),
    Chats(),
    Posts(),
    Users(),
    SettingsScreen(),
  ];
  // List TO Change Title When Change NavBar Screen
  List<String> appBarTitle = [
    'New Feed',
    'Chats',
    'Posts',
    'Users',
    'Settings',
  ];

  // File Save Image Which Selected From Gallary
  File? profileImageFile;
  // ImagePicker Go To Get Images From Gallary
  var picker = ImagePicker();

  // Function To Change Profile Image
  Future<void> getProfileImage() async {
    picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (picker != null) {
      profileImageFile = File(pickedFile!.path);
      print('Get Image');
      print(pickedFile.path);
      emit(GetProfileImageSuccess());
    } else {
      print('No Image Selected');
      emit(GetProfileImageError());
    }
  }

  // File Save Image Which Selected From Gallary
  File? coverImageFile;
  // Function To Change Cover Image
  Future<void> getCoverImage() async {
    picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (picker != null) {
      coverImageFile = File(pickedFile!.path);
      emit(GetProfileImageSuccess());
    } else {
      print('No Image Selected');
      emit(GetProfileImageError());
    }
  }

  String profileImageUrl = ''; // Save New ProfileImage Url in This Variable

  // Function to Upload Image On FireStorage
  // image_picker2429355068206347786.jpg
  // cheak Rules In Fire Storage
  uploadProfileImage() {
    firebase_storage.FirebaseStorage.instance
        .ref()
        // child create Folder To Save Path Image // Uri To Get true url From File profileImage
        .child('users/${Uri.file(profileImageFile!.path).pathSegments.last}')
        //  putFile Save The Image
        .putFile(profileImageFile!)
        .then((value) {
      print('First Then Upload');
      // getDownloadURL Get Image From Firebase
      value.ref.getDownloadURL().then((value) {
        profileImageUrl = value;
        // updateOnly To Update Image Only and put in other image The current url
        // لازم اباصي ال يول بتاع الصورة الى متغيرتش علشان بيتمسح من ال فيربيز انا هنا ف البروفيل بباصي الالصورة الكبيرة "cover"
        updateOnly(coverImage: model!.cover);
        emit(UploadProfileImageSuccess());
        print('getDownloadURL Done');
      }).catchError((error) {
        emit(UploadProfileImageError());
        print('Error In Upload Profile Image in Then one');
      });
    }).catchError((error) {
      emit(UploadProfileImageError());
      print('Error In Upload Profile Image in Then Tow');
    });
  }

  String coverImageUrl = ''; // Save New CoverImage Url in This Variable

  // Function to Upload Image On FireStorage
  // image_picker2429355068206347786.jpg
  // cheak Rules In Fire Storage
  void uploadCoverImage() {
    firebase_storage.FirebaseStorage.instance
        .ref()
        // child create Folder To Save Path Image // Uri To Get true url From File CoverImage
        .child('users/${Uri.file(coverImageFile!.path).pathSegments.last}')
        //  putFile Save The Image
        .putFile(coverImageFile!)
        .then((value) {
      print('First Then Upload');
      // getDownloadURL Get Image From Firebase
      value.ref.getDownloadURL().then((value) {
        coverImageUrl = value;
        // updateOnly To Update Image Only and put in other image The current url
        // لازم اباصي ال يول بتاع الصورة الى متغيرتش علشان بيتمسح من ال فيربيز انا هنا ف الاميج بباصي الالصورة الكبيرة "image"
        updateOnly(profileImage: model!.image);

        emit(UploadCoverImageSuccess());
        print('getDownloadURL Done');
      }).catchError((error) {
        emit(UploadCoverImageError());
        print('Error In Upload Cover Image in Then one');
      });
    }).catchError((error) {
      emit(UploadCoverImageError());
      print('Error In Upload Cover Image in Then Tow');
    });
  }

  void updateUserData({
    String? fristName,
    String? phone,
    String? bio,
    String? email,
    String? coverImage,
    String? profileImage,
  }) {
    // take instance from class UserModel To Send From toMap Function
    UserModel newUserData = UserModel(
      fristName: fristName ?? model!.fristName,
      bio: bio ?? model!.bio,
      phone: phone ?? model!.phone,
      email: email ?? model!.email,
      isVerify: model!.isVerify,
      password: model!.password,
      uId: model!.uId,
      cover: coverImage != null ? model!.cover! : coverImageUrl,
      image: profileImage != null ? model!.image! : profileImageUrl,
    );
    emit(UpdateUsersDataLoadingState());
    // If Cover Image Change
    if (coverImageFile != null) {
      // Updload Cover Image And There Func "uploadCoverImage()" Update Only
      uploadCoverImage();
      print('uploadCoverImage');
      // If Profile Image Change
    } else if (profileImageFile != null) {
      // Updload Profile Image And There Func "uploadProfileImage()" Update Only
      uploadProfileImage();
      print('uploadProfileImage');
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .doc(model!.uId)
          .update(newUserData.toMap())
          .then((value) {
        print('Upadate Done');
        getUserData();
      }).catchError((error) {});
    }
  }

  // Function To Update Image Only Without other data
  void updateOnly(
      {String? fristName,
      String? phone,
      String? bio,
      String? email,
      String? coverImage,
      String? profileImage}) {
    // Model To Pass New User Data To Firebase
    UserModel newUserData = UserModel(
      fristName: fristName ?? model!.fristName,
      bio: bio ?? model!.bio,
      phone: phone ?? model!.phone,
      email: email ?? model!.email,
      isVerify: model!.isVerify,
      password: model!.password,
      uId: model!.uId,
      cover: coverImage != null ? model!.cover! : coverImageUrl,
      image: profileImage != null ? model!.image! : profileImageUrl,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uId)
        .update(newUserData.toMap())
        .then((value) {
      // علشان لو لسة مغير الصور وعاوز أغير الكلام يرجع نل ويغير الكلام
      coverImageFile = null;
      profileImageFile = null;
      print('Upadate Done');
      getUserData();
    }).catchError((error) {});
  }

  File? postImageFile;
  String postImageUrl = '';


  // Upload Post Image And Create Post In There
  void uploadPostImage
  (
    {String? text,
    }
  ) {
    emit(CreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        // child create Folder To Save Path Image // Uri To Get true url From File CoverImage
        .child('posts/${Uri.file(postImageFile!.path).pathSegments.last}')
        //  putFile Save The Image
        .putFile(postImageFile!)
        .then((value) {
      print('First Then Upload Image Post');
      // getDownloadURL Get Image From Firebase
      value.ref.getDownloadURL().then((value) {
        postImageUrl = value;
        createPost(dateTime: DateTime.now().toString(),postImage: value,text: text);
        emit(UploadPostImageSuccess());
        print('getDownloadURL Done in Upload post image');
      }).catchError((error) {
        emit(UploadPostImageError());
        print('Error In Upload Post Image in Then one');
      });
    }).catchError((error) {
      emit(UploadPostImageError());
      print('Error In Upload Post Image in Then Tow');
    });
  }

  Future<void> getPostImage() async {
    picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (picker != null) {
      postImageFile = File(pickedFile!.path);
      emit(GetPostImageSuccess());
    } else {
      print('No Image Selected');
      emit(GetPostImageError());
    }
  }

  // Create Post Without Image Like Create User In Register
  void createPost({
    String? postImage,
    String? dateTime,
    String? text,
    String? id,
  }) 
  {
    // Model To Pass New User Data To Firebase
    PostModel newPost = PostModel(
      fristName: model!.fristName,
      uId: model!.uId,
      dateTime: dateTime,
      text: text,
      image: model!.image!,
      postImage: postImage ?? '',
    );
    if(text !=null && postImage!=null)
    FirebaseFirestore.instance
        .collection('posts')
        .add(newPost.toMap())
        .then((value) {
          postImageFile == null ;
          getPosts();
          print('Create Post Done');
      emit(CreatePostSuccessState());
    }).catchError((error) {
      print('Error In Create Post => $error');
      emit(CreatePostErrorState());
    });
  }
  
  // Remove post Image Which Selected
  void closedPostImage()
  {
    postImageFile = null;
    emit(ClosedPostImageSuccess());
  }

List<PostModel> posts = [];
  void getPosts()
  {
    posts = [];
    emit(GetPostsLoadingState());
    FirebaseFirestore.instance.collection('posts').get().then((value) 
    {
      value.docs.forEach((element)
      {
        posts.add(PostModel.fromJson(element.data()));
      });
      print('Get Posts Done');
      emit(GetPostsSuccessState());
    }).catchError((error)
    {
      print('Error In Get posts');
      emit(GetPostsErrorState());
    });
  }
}

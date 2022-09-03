import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/Constance/constance.dart';
import 'package:firebase_app/Screens/layout_screen/layout_cubit/cubit_state.dart';
import 'package:firebase_app/Screens/layout_screen/screens/chats/chats.dart';
import 'package:firebase_app/Screens/layout_screen/screens/users/users.dart';
import 'package:firebase_app/model/chat_model/chat_model.dart';
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
    if (currentIndex == 1) {
      getAllUsers();
    }
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
  }) 
  {
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
      String? profileImage}) 
      {
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
  void uploadPostImage({
    String? text
  }) 
  {
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
        createPost(
            dateTime: DateTime.now().toString(), postImage: value, text: text);
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
    String? id
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
    if (text != null && postImage != null)
      FirebaseFirestore.instance
          .collection('posts')
          .add(newPost.toMap())
          .then((value) {
        postImageFile == null;
        getPosts();
        print('Create Post Done');
        emit(CreatePostSuccessState());
      }).catchError((error) {
        print('Error In Create Post => $error');
        emit(CreatePostErrorState());
      });
  }

  // Remove post Image Which Selected
  void closedPostImage() {
    postImageFile = null;
    emit(ClosedPostImageSuccess());
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];
  List<int> comments = [];

  void getPosts() {
    posts = [];
    postsId = [];
    likes = [];
    comments = [];
    emit(GetPostsLoadingState());
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        // Enter In Likes Collections Adn Get Number Of Users Click Like And Save In Likes List
        element.reference.collection('likes').get().then((valueLikes) {
          element.reference.collection('comments').get().then((valueComments) {
            comments.add(valueComments.docs.length);
            likes.add(valueLikes.docs.length);
            posts.add(PostModel.fromJson(element.data()));

            postsId.add(element.id);
            emit(GetPostsSuccessState());
          });
        });
      });
      print('Get Posts Done');
    }).catchError((error) {
      print('Error In Get posts');
      emit(GetPostsErrorState());
    });
  }

  // Save Like in Firebase In New Coolection In post Collection With post Id
  void postLike(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(model!.uId)
        .set({'like': true}).then((value) {
      print('Like');
      emit(PostsLikesSuccessState());
    }).catchError((error) {
      print('Error In Posts Likes');
      emit(PostsLikesErrorState());
    });
  }

// Save Comments in Firebase In New Coolection In post Collection With post Id
  void postComment(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(model!.uId)
        .set({'comment': true}).then((value) {
      print('Comment');
      emit(PostsLikesSuccessState());
    }).catchError((error) {
      print('Error In Posts Comment');
      emit(PostsLikesErrorState());
    });
  }

  List<UserModel> users = [];
  // Get All User In Chat Screen
  void getAllUsers() {
    emit(GetUsersChatsLoadingState());
    if (users.isEmpty) {
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          uId == element.id
              ? users.remove(UserModel.fromJson(element.data()))
              : users.add(UserModel.fromJson(element.data()));
          emit(GetUsersChatsSuccessState());
          print('Get All Users Done');
        });
        print('Get All Users Done');
      }).catchError((error) {
        print('error In Get Users Chats => $error');
        emit(GetUsersChatsErrorState());
      });
    }
  }

  //  Send Message From Sender Id And Recever Id
  void sentMessage({
    required String receverId,
    required String text,
    required String dateTime,
    required String image,
  }) 
  {
    ChatModel chatModel = ChatModel(
        dateTime: dateTime,
        receverid: receverId,
        senderId: model!.uId,
        text: text,
        image: image);
    //  save in sender Id email in firebase
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uId)
        .collection('chats')
        .doc(receverId)
        .collection('messages')
        .add(chatModel.toMap())
        .then((value) {
      if (messageImageFile != null) {
        uploadMessageImage();
        
        emit(SendMessagsSuccessState());
      }
      emit(SendMessagsSuccessState());
    }).catchError((error) {
      emit(SendMessagsErrorState());
    });

    //  save in recever Id email in firebase

    FirebaseFirestore.instance
        .collection('users')
        .doc(receverId)
        .collection('chats')
        .doc(model!.uId)
        .collection('messages')
        .add(chatModel.toMap())
        .then((value) {
      emit(SendMessagsSuccessState());
    }).catchError((error) {
      emit(SendMessagsErrorState());
    });
  }

  List<ChatModel> messages = [];
    // Get Message In Chat Screen Details
  void getMessage({
    required String receverId,
  }) 
  {
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uId)
        .collection('chats')
        .doc(receverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];

      event.docs.forEach((element) {
        messages.add(ChatModel.fromJson(element.data()));
      });
      emit(GetMessagsSuccessState());
    });
  }

  File? messageImageFile;
  String messageImageUrl = '';

  Future<void> getMessageImage() async {
    messageImageFile = null;
    picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (picker != null) {

      messageImageFile = File(pickedFile!.path);
      
      emit(GetMessageImageSuccess());
    } else {
      print('No Image Selected');
      emit(GetMessageImageError());
    }
  }

  // Upload Image In Chat
  void  uploadMessageImage() {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('user/${Uri.file(messageImageFile!.path).pathSegments.last}')
        .putFile(messageImageFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        messageImageUrl = value;
        
        
        emit(UploadMessageImageSuccess());
        print('getDownloadURL Message Done in Upload Message image');
        
      }).catchError((error) {
        emit(UploadMessageImageError());
        print('Error In Upload Message Image in Then one');
      });
      messageImageUrl= '';
      print('messageImageFile Null Done');
    }).catchError((error) {
      emit(UploadMessageImageError());
      print('Error In Upload Message Image in Then Tow');
    });
  }
  void closedMessageImage() {
    messageImageFile = null;
    emit(ClosedPostImageSuccess());
  }
}

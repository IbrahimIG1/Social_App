/*  this class For User Data In FireStore */
class UserModel {
  String? fristName;
  String? bio;

  String? phone;
  String? email;
  String? password;
  String? uId;
  String? cover;
  String? image;
  bool? isVerify;

  UserModel(
      {this.email,
       this.fristName,
       this.bio,
      this.password,
       this.phone,
      this.uId,
       this.image,
       this.cover,
      this.isVerify});
  UserModel.fromJson(Map<String, dynamic> json) {
    fristName = json['first_name'];
    bio = json['bio'];

    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    uId = json['uId'];
    image = json['image'];
    cover = json['cover'];
    isVerify = json['isVerify'];
  }
  Map<String, dynamic> toMap() {
    return {
      'first_name': fristName,
      'bio': bio,
      'phone': phone,
      'email': email,
      'password': password,
      'uId': uId,
      'image': image,
      'cover': cover,
      'isVerify': isVerify,
    };
  }
}

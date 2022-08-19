/*  this class For User Data In FireStore */
class UserModel {
  String? fristName;
  String? lastName;
  String? phone;
  String? email;
  String? password;
  String? uId;
  String? cover;
  String? image;
  bool? isVerify;

  UserModel(
      {required this.email,
      required this.fristName,
      required this.lastName,
      required this.password,
      required this.phone,
      required this.uId,
      required this.image,
      required this.cover,
      required this.isVerify});
  UserModel.fromJson(Map<String, dynamic> json) {
    fristName = json['first_name'];
    lastName = json['last_name'];
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
      'last_name': lastName,
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

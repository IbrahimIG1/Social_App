/*  this class For Post Data In FireStore */
class PostModel {
  String? fristName;
  String? uId;
  String? image;
  String? text;
  String? dateTime;
  String? postImage;

  PostModel({
    this.fristName,
    this.uId,
    this.image,
    this.text,
    this.dateTime,
    this.postImage,
    

  });
  PostModel.fromJson(Map<String, dynamic> json) {
    fristName = json['first_name'];
    uId = json['uId'];
    image = json['image'];
    text = json['text'];
    dateTime = json['dateTime'];
    postImage = json['postImage'];
  }
  Map<String, dynamic> toMap() {
    return {
      'first_name': fristName,
      'uId': uId,
      'image': image,
      'text': text,
      'dateTime': dateTime,
      'postImage': postImage,
    };
  }
}

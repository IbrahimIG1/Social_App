/*  this class For Chat Data In FireStore */
class ChatModel {
  String? text;
  String? dateTime;
  String? senderId;
  String? receverid;
  String? image;

  ChatModel({
    this.text,
    this.dateTime,
    this.senderId,
    this.receverid,
    this.image,
  });
  ChatModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    dateTime = json['dateTime'];

    senderId = json['senderId'];
    receverid = json['receverid'];
    image = json['image'];
  }
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'dateTime': dateTime,
      'receverid': receverid,
      'image': image,
    };
  }
}

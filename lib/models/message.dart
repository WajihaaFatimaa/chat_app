class Message {
  final String msgID;
  final int senderId;
  final int recieverId;
  final String? message;
  final String? image;
  final String? messageDate;
  final int status;

  Message(
      {required this.msgID,
      required this.senderId,
      required this.recieverId,
      required this.message,
      required this.messageDate,
      required this.image,
      required this.status});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        msgID: json['id'] as String,
        senderId: json['senderID'] as int,
        recieverId: json['recieverID'] as int,
        messageDate: json['msgDate'] as String? ?? '',
        message: json['messsage'] as String? ?? '',
        image: json['image'] as String? ?? '',
        status: json['msgStatus'] as int);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": msgID,
      "senderID": senderId,
      "recieverID": recieverId,
      "messsage": message,
      "image": image,
      "msgDate": messageDate,
      "msgStatus": status,
    };
  }
}

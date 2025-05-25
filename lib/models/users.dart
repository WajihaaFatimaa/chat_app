class User {
  final int id;
  final String userName;
  final String userEmail;
  final String userPassword;
  final int phNumber;
  final String? userImage;
  final int status;

  User(
      {required this.id,
      required this.userName,
      required this.userEmail,
      required this.userPassword,
      required this.phNumber,
      this.userImage,
      required this.status});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['userId'] as int,
        userName: json['userName'] as String,
        userEmail: json['userEmail'] as String,
        userPassword: json['userPassword'] as String,
        phNumber: json['userPhoneNo'] as int,
        userImage: json['userImage'] as String? ?? '',
        status: json['userStatus'] as int);
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": id,
      "userName": userName,
      "userEmail": userEmail,
      "userPhoneNo": phNumber,
      "userPassword": userPassword,
      "userImage": userImage,
      "userStatus": status,
    };
  }
}

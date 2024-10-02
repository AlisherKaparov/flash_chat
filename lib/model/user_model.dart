class UserModel {
  final String userId;
  final String userName;
  final String email;

  UserModel(
      {required this.userId, required this.userName, required this.email});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'userName': userName,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      email: map['email'] as String,
    );
  }
}

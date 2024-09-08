import 'dart:convert';

class UserModel {
  String name;
  String email;
  String imgUrl;
  String phNo;
  String uid;
  UserModel({
    required this.name,
    required this.email,
    required this.imgUrl,
    required this.phNo,
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'email': email});
    result.addAll({'imgUrl': imgUrl});
    result.addAll({'phone': phNo});
    result.addAll({'userId': uid});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      imgUrl: map['imgUrl'] ?? '',
      phNo: map['phone'] ?? '',
      uid: map['userId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}

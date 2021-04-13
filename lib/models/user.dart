


class UserModel
{
  String uid, name, email, accountType;


  UserModel({this.uid, this.name, this.email, this.accountType});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return new UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      accountType: map['accountType'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'uid': this.uid,
      'name': this.name,
      'email': this.email,
      'accountType': this.accountType,
    } as Map<String, dynamic>;
  }
}



class UserModel {
  String? email;
  String? name;
  String? wrool;
  String? uid;
  String? role;
  String? gender;

// receiving data
  UserModel(
      {this.uid, this.email, this.wrool, this.name, required String role, this.gender});
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      wrool: map['wrool'],
      gender: map['gender'],
      role: '',
    );
  }
// sending data
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'wrool': wrool,
      'gender':gender,
    };
  }
}

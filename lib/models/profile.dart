import 'package:jeya_engineering/enum.dart';

class Profile {
  Profile({
    required this.name,
    required this.email,
    required this.role,
    this.phone, required this. uid,
  });

  String name;
  String email;
  Role role;
  String? phone;
  String? uid;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        name: json["name"],
        email: json["email"],
        role: Role.values.elementAt(json["role"]),
        phone: json["phone"], uid: json['uid']??'',
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "role": role.index,
        "phone": phone,
        "uid":uid
      };
}

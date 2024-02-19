import 'package:flutter/cupertino.dart';
import 'package:jeya_engineering/enum.dart';
import 'package:jeya_engineering/models/profile.dart';

class ProfileFormController {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  Role role = Role.admin;
  TextEditingController phone = TextEditingController();
  String uid="";

  ProfileFormController();

  Profile get profile => Profile(name: name.text, email: email.text, role: role, phone: phone.text,uid:uid);

  factory ProfileFormController.fromProfile(Profile profile) {
    var controller = ProfileFormController();
    controller.name.text = profile.name;
    controller.email.text = profile.email;
    controller.role = profile.role;
    controller.phone.text = profile.phone ?? '';
    controller.uid=profile.uid??'';
    return controller;
  }
}

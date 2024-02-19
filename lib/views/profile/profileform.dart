import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jeya_engineering/Controllers/auth_controller.dart';
import 'package:jeya_engineering/FormController/profile.dart';
import 'package:jeya_engineering/enum.dart';
import 'package:jeya_engineering/firebase.dart';
import 'package:jeya_engineering/models/response.dart';
import 'package:jeya_engineering/widgets/drop_down.dart';
import 'package:jeya_engineering/widgets/text_box.dart';
import 'package:jeya_engineering/widgets/utilities.dart';

import '../../models/profile.dart';

class ProfileForm extends StatelessWidget {
  const ProfileForm({Key? key, this.profile, required this.isEdit})
      : super(key: key);

  final Profile? profile;
  final bool isEdit;
  @override
  Widget build(BuildContext context) {
    var controller = profile == null
        ? ProfileFormController()
        : ProfileFormController.fromProfile(profile!);

    return Material(
      child: SizedBox(
        width: 250,
        child: SingleChildScrollView(
          child: Column(children: [
            CustomTextBox(
              hintText: 'Name',
              controller: controller.name,
            ),
            CustomTextBox(
              hintText: 'Email',
              controller: controller.email,
            ),
            CustomTextBox(
              hintText: 'Phone',
              controller: controller.phone,
            ),
            CustomDropdown<Role>(
              value: controller.role,
              onChanged: ((p0) => controller.role = p0 ?? controller.role),
              title: 'Role',
              items: Role.values
                  .map((e) => DropdownMenuItem(
                        child: Text(e.name.toUpperCase()),
                        value: e,
                      ))
                  .toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  var future;
                  if (isEdit == false) {
                    HttpsCallable callable =
                        FirebaseFunctions.instance.httpsCallable('createUser');
                    try {
                      var token = await auth.currentUser?.getIdToken();
                       future =  callable.call({
                        "token": token,
                        "email": controller.email.text.trim(),
                        "phoneNumber": controller.phone.text,
                        "password": '12345678',
                        "displayName": controller.name.text,
                        "photoURL":
                            'https://cdn-icons-png.flaticon.com/512/4322/4322991.png',
                        "role": controller.role.name
                      }).then((value) {
                        Map<String, dynamic> result = value.data;
                        controller.uid = result['data'];
                        profiles
                            .doc(controller.uid)
                            .set(controller.profile.toJson())
                            .then((value) => Navigator.of(context).pop());
                        if (kDebugMode) {
                          print(controller.uid);
                        }

                        if (kDebugMode) {
                          print(value.data.toString());
                        }
                      }).then((value) => Result.success("User created Succesfully")).onError((error, stackTrace) => Result.error(error.toString()));
                    } catch (e) {
                      if (kDebugMode) {
                        print(e.toString());
                      }
                    }
                    ;
                  } else
                  {
                    HttpsCallable callable2 =
                        FirebaseFunctions.instance.httpsCallable('updateUser');

                    if (kDebugMode) {
                      print(controller.uid);
                    }
                    var token = await auth.currentUser?.getIdToken();
                    future =  callable2.call({
                      "token": token,
                      "email": controller.email.text.trim(),
                      "phoneNumber": controller.phone.text,
                      "displayName": controller.name.text,
                      "photoURL":
                      'https://cdn-icons-png.flaticon.com/512/4322/4322991.png',
                      "role": controller.role.name,
                      "uid": controller.uid
                    }).then((value) {
                      return profiles
                          .doc(controller.uid)
                          .update(controller.profile.toJson())
                      // .then((value) => ScaffoldMessenger.of(context)
                      //     .showSnackBar(SnackBar(
                      //         content: Text(
                      //             '${controller.name.text} was edited successfully'))))
                          .then((value) => Result.success("User updated succesfully")).onError((error, stackTrace) => Result.error(error.toString()));
                      // if (kDebugMode) {
                      //   print(controller.uid);
                      // }

                      if (kDebugMode) {
                        print(value.data.toString());
                      }
                    }).catchError((error) {
                      return Result.error(error.toString());
                    });
                    ;
                  }

                  showFutureDialog(context: context, future: future);
                },
                child: const Text("Submit"),
              ),
            )
          ]),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jeya_engineering/views/job/job_list.dart';
import 'package:jeya_engineering/views/job/new_job_list.dart';
import 'package:jeya_engineering/views/login_page.dart';

import 'Controllers/auth_controller.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: auth.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if ((snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done)) {
            if (snapshot.data != null) {
              if (kIsWeb == false) {
                FirebaseMessaging.instance
                    .subscribeToTopic('jobChannel')
                    .then((value) {
                  printInfo(info: 'FCM subscribed');
                });
              }
              auth.loadClaims();
              return const NewJobList();
            } else {
              if (kIsWeb == false) {
                FirebaseMessaging.instance.unsubscribeFromTopic('jobChannel');
              }
              return const LoginPage();
            }
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return const Center(
            child: Text("Something happening"),
          );
        },
      ),
    );
  }
}

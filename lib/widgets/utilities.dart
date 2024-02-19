import 'package:flutter/material.dart';

import '../models/response.dart';

getHeight(context) => MediaQuery.of(context).size.height;
getWidth(context) => MediaQuery.of(context).size.width;

showFutureDialog({required BuildContext context, required Future<dynamic> future, List<Widget>? actions}) {
  showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
                var response = snapshot.data as Result;
                return AlertDialog(
                  title: Text(response.code),
                  content: Text(response.message),
                  actions: (response.code == 'Error' || actions == null)
                      ? [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Okay"))
                        ]
                      : actions,
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            });
      });
}

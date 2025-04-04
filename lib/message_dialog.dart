/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyber_toolbox/main.dart';
import 'package:flutter/material.dart';

void showMessageDialog(
  String title,
  String message,
) {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (
      BuildContext context,
    ) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

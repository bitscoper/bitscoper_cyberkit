/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

void showMessageDialog(
  BuildContext context,
  String title,
  String message, {
  void Function()? onOK,
}) {
  try {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                try {
                  if (onOK != null) {
                    onOK();
                  }

                  Navigator.of(context).pop();
                } catch (error) {
                  debugPrint(error.toString());
                } finally {}
              },
              child: Text(AppLocalizations.of(context)!.ok),
            ),
          ],
        );
      },
    );
  } catch (error) {
    debugPrint(error.toString());
  } finally {}
}

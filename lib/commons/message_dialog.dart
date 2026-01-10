/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:flutter/material.dart';

void showMessageDialog(String title, String message, {void Function()? onOK}) {
  try {
    showDialog(
      context: navigatorKey.currentContext!,
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
                  showMessageDialog(
                    AppLocalizations.of(context)!.error,
                    error.toString(),
                  );
                } finally {}
              },
              child: Text(AppLocalizations.of(context)!.ok),
            ),
          ],
        );
      },
    );
  } catch (error) {
    showMessageDialog(
      AppLocalizations.of(navigatorKey.currentContext!)!.error,
      error.toString(),
    ); /* 😆 */
  } finally {}
}

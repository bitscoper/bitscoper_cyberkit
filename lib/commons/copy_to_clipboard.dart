/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyber_toolbox/commons/message_dialog.dart';
import 'package:bitscoper_cyber_toolbox/l10n/app_localizations.dart';
import 'package:bitscoper_cyber_toolbox/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void copyToClipboard(String dataType, String string) {
  try {
    if (dataType.isNotEmpty && string.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: string));

      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(
            '$dataType ${AppLocalizations.of(navigatorKey.currentContext!)!.copied_to_clipboard}',
          ),
        ),
      );
    }
  } catch (error) {
    showMessageDialog("Error", error.toString());
  } finally {}
}

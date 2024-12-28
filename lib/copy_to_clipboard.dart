/* By Abdullah As-Sadeed */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void copyToClipBoard(
  BuildContext context,
  String dataType,
  String string,
) {
  if (dataType.isNotEmpty && string.isNotEmpty) {
    Clipboard.setData(
      ClipboardData(
        text: string,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$dataType copied to clipboard!'),
      ),
    );
  }
}

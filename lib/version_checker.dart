/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:yaml/yaml.dart';

Future<String> getVersion() async {
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}

String skipBuildNumber(String version) {
  return version.split('+').first;
}

Future<void> checkVersion() async {
  try {
    Navigator.of(navigatorKey.currentContext!).pop();

    final ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(
      navigatorKey.currentContext!,
    );

    final SnackBar snackBar = SnackBar(
      content: Text(
        AppLocalizations.of(navigatorKey.currentContext!)!.checking_version,
      ),
    );

    scaffoldMessenger.showSnackBar(snackBar);

    final response = await http.get(
      Uri.parse(
        'https://raw.githubusercontent.com/bitscoper/Bitscoper_CyberKit/refs/heads/main/pubspec.yaml',
      ),
    );

    if (response.statusCode == 200) {
      final String localVersion = await getVersion();

      final dynamic yamlMap = loadYaml(response.body);
      final String remoteVersion = yamlMap['version'].toString();

      final String remoteVersionShort = skipBuildNumber(remoteVersion);
      final String localVersionShort = skipBuildNumber(localVersion);

      if (remoteVersionShort != localVersionShort) {
        scaffoldMessenger.hideCurrentSnackBar();

        showMessageDialog(
          AppLocalizations.of(navigatorKey.currentContext!)!.available_update,
          "${AppLocalizations.of(navigatorKey.currentContext!)!.latest_version}: $remoteVersionShort\n${AppLocalizations.of(navigatorKey.currentContext!)!.your_version}: $localVersion",
        );
      } else {
        scaffoldMessenger.hideCurrentSnackBar();

        showMessageDialog(
          AppLocalizations.of(navigatorKey.currentContext!)!.up_to_date,
          AppLocalizations.of(
            navigatorKey.currentContext!,
          )!.you_are_using_the_latest_version,
        );
      }
    } else {
      scaffoldMessenger.hideCurrentSnackBar();

      showMessageDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        response.statusCode.toString(),
      );
    }
  } catch (error) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).hideCurrentSnackBar();

    showMessageDialog(
      AppLocalizations.of(navigatorKey.currentContext!)!.error,
      error.toString(),
    );
  } finally {}
}

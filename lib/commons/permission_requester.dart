/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:permission_handler/permission_handler.dart';

Future<PermissionStatus> requestPermission(
  Permission permission,
  void Function() onGranted,
) async {
  PermissionStatus permissionStatus = PermissionStatus.denied;

  try {
    final String permissionName = permission
        .toString()
        .split('.')
        .last
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (Match match) => ' ${match.group(0)!.toLowerCase()}',
        );

    showMessageDialog(
      AppLocalizations.of(navigatorKey.currentContext!)!.permission,
      '${AppLocalizations.of(navigatorKey.currentContext!)!.the}"$permissionName" ${AppLocalizations.of(navigatorKey.currentContext!)!.permission_will_be_used}',
      onOK: () async {
        permissionStatus = await permission
            .onDeniedCallback(() {
              showMessageDialog(
                AppLocalizations.of(navigatorKey.currentContext!)!.denied,
                '${AppLocalizations.of(navigatorKey.currentContext!)!.the}"$permissionName" ${AppLocalizations.of(navigatorKey.currentContext!)!.permission_is_denied}!',
              );
            })
            .onGrantedCallback(() {
              onGranted();
            })
            .onPermanentlyDeniedCallback(() async {
              showMessageDialog(
                AppLocalizations.of(
                  navigatorKey.currentContext!,
                )!.permanently_denied,
                '${AppLocalizations.of(navigatorKey.currentContext!)!.the}"$permissionName" ${AppLocalizations.of(navigatorKey.currentContext!)!.permission_is_permanently_denied}!',
                onOK: () async {
                  if (!await openAppSettings()) {
                    showMessageDialog(
                      AppLocalizations.of(navigatorKey.currentContext!)!.error,
                      AppLocalizations.of(
                        navigatorKey.currentContext!,
                      )!.the_application_settings_could_not_be_opened_in_system_settings,
                    );
                  }
                },
              );
            })
            .onRestrictedCallback(() {
              showMessageDialog(
                AppLocalizations.of(navigatorKey.currentContext!)!.restricted,
                '${AppLocalizations.of(navigatorKey.currentContext!)!.the}"$permissionName" ${AppLocalizations.of(navigatorKey.currentContext!)!.permission_is_restricted}!',
              );
            })
            .onLimitedCallback(() {
              showMessageDialog(
                AppLocalizations.of(navigatorKey.currentContext!)!.limited,
                '${AppLocalizations.of(navigatorKey.currentContext!)!.the}"$permissionName" ${AppLocalizations.of(navigatorKey.currentContext!)!.permission_is_limited}!',
              );
            })
            .onProvisionalCallback(() {
              showMessageDialog(
                AppLocalizations.of(navigatorKey.currentContext!)!.provisional,
                '${AppLocalizations.of(navigatorKey.currentContext!)!.the}"$permissionName" ${AppLocalizations.of(navigatorKey.currentContext!)!.permission_is_provisional}!',
              );
            })
            .request();
      },
    );

    return permissionStatus;
  } catch (error) {
    showMessageDialog(
      AppLocalizations.of(navigatorKey.currentContext!)!.error,
      error.toString(),
    );

    return permissionStatus;
  } finally {}
}

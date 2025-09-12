/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyber_toolbox/commons/message_dialog.dart';
import 'package:bitscoper_cyber_toolbox/l10n/app_localizations.dart';
import 'package:bitscoper_cyber_toolbox/main.dart';
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
      'Permission',
      'The "$permissionName" permission will be used.',
      onOK: () async {
        permissionStatus = await permission
            .onDeniedCallback(() {
              showMessageDialog(
                'Denied',
                'The "$permissionName" permission is denied!',
              );
            })
            .onGrantedCallback(() {
              onGranted();
            })
            .onPermanentlyDeniedCallback(() async {
              showMessageDialog(
                'Permanently Denied',
                'The "$permissionName" permission is permanently denied!',
                onOK: () async {
                  if (!await openAppSettings()) {
                    showMessageDialog(
                      AppLocalizations.of(navigatorKey.currentContext!)!.error,
                      'The application settings could not be opened in the system settings!',
                    );
                  }
                },
              );
            })
            .onRestrictedCallback(() {
              showMessageDialog(
                'Restricted',
                'The "$permissionName" permission is restricted!',
              );
            })
            .onLimitedCallback(() {
              showMessageDialog(
                'Limited',
                'The "$permissionName" permission is limited!',
              );
            })
            .onProvisionalCallback(() {
              showMessageDialog(
                'Provisional',
                'The "$permissionName" permission is provisional!',
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

// TODO: Localisation

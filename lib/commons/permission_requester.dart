/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyber_toolbox/commons/message_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

Future<PermissionStatus> requestPermission(
  Permission permission,
  void Function() onGranted,
) async {
  PermissionStatus permissionStatus = PermissionStatus.denied;

  try {
    final String permissionName = permission.toString().replaceFirst(
      'Permission.',
      '',
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
                      "Error",
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
    showMessageDialog("Error", error.toString());

    return permissionStatus;
  } finally {}
}

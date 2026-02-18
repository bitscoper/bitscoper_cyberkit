/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

String _makePermissionNameReadable(Permission permission) {
  return permission
      .toString()
      .split('.')
      .last
      .replaceAllMapped(
        RegExp(r'([A-Z])'),
        (Match match) => ' ${match.group(0)!.toLowerCase()}',
      );
}

String _formatPermissionResults(
  Map<Permission, PermissionStatus> permissionStatuses,
) {
  final List<String> denied = <String>[];
  final List<String> permanentlyDenied = <String>[];
  final List<String> restricted = <String>[];

  final List<String> lines = <String>[];

  permissionStatuses.forEach((
    Permission permission,
    PermissionStatus permissionStatus,
  ) {
    final String name = '"${_makePermissionNameReadable(permission)}"';

    if (permissionStatus.isDenied) {
      denied.add(name);
    } else if (permissionStatus.isPermanentlyDenied) {
      permanentlyDenied.add(name);
    } else if (permissionStatus.isRestricted) {
      restricted.add(name);
    }
  });

  if (denied.isNotEmpty) {
    lines.add('Denied: ${denied.join(', ')}');
  }
  if (permanentlyDenied.isNotEmpty) {
    lines.add('Permanently Denied: ${permanentlyDenied.join(', ')}');
  }
  if (restricted.isNotEmpty) {
    lines.add('Restricted: ${restricted.join(', ')}');
  }
  return lines.join('\n');
}

Future<void> requestPermissions(
  List<Permission> permissions,
  VoidCallback onAllGranted,
) async {
  try {
    final String permissionNames = permissions
        .map(_makePermissionNameReadable)
        .map((String permission) => '"$permission"')
        .join(', ');

    showMessageDialog(
      AppLocalizations.of(navigatorKey.currentContext!)!.permissions,
      '$permissionNames ${AppLocalizations.of(navigatorKey.currentContext!)!.permissions_will_be_used}',
      onOK: () async {
        final Map<Permission, PermissionStatus> permissionStatuses =
            await permissions.request();

        if (permissionStatuses.values.any(
          (PermissionStatus permissionStatus) =>
              permissionStatus.isDenied ||
              permissionStatus.isPermanentlyDenied ||
              permissionStatus.isRestricted,
        )) {
          final String details = _formatPermissionResults(permissionStatuses);

          showMessageDialog(
            AppLocalizations.of(navigatorKey.currentContext!)!.permissions,
            details,
            onOK: () async {
              if (permissionStatuses.values.any(
                (PermissionStatus permissionStatus) =>
                    permissionStatus.isPermanentlyDenied,
              )) {
                await openAppSettings();
              }
            },
          );

          return;
        }

        onAllGranted();
      },
    );
  } catch (error) {
    debugPrint(error.toString());

    showMessageDialog(
      AppLocalizations.of(navigatorKey.currentContext!)!.error,
      error.toString(),
    );
  } finally {}
}

/* "Provisional" and "Limited" permissions do not require reporting. */

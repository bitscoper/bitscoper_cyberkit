/* By Abdullah As-Sadeed */

import 'dart:io';
import 'package:bitscoper_cyberkit/commons/application_toolbar.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:bitscoper_cyberkit/tool_pages/base_encoder.dart';
import 'package:bitscoper_cyberkit/tool_pages/bluetooth_low_energy_scanner.dart';
import 'package:bitscoper_cyberkit/tool_pages/cvss_calculator.dart';
import 'package:bitscoper_cyberkit/tool_pages/dns_record_retriever.dart';
import 'package:bitscoper_cyberkit/tool_pages/file_hash_calculator.dart';
import 'package:bitscoper_cyberkit/tool_pages/ipv4_subnet_scanner.dart';
import 'package:bitscoper_cyberkit/tool_pages/mdns_scanner.dart';
import 'package:bitscoper_cyberkit/tool_pages/morse_code_translator.dart';
import 'package:bitscoper_cyberkit/tool_pages/ogp_data_extractor.dart';
import 'package:bitscoper_cyberkit/tool_pages/pinger.dart';
import 'package:bitscoper_cyberkit/tool_pages/qr_code_generator.dart';
import 'package:bitscoper_cyberkit/tool_pages/route_tracer.dart';
import 'package:bitscoper_cyberkit/tool_pages/series_uri_crawler.dart';
import 'package:bitscoper_cyberkit/tool_pages/string_hash_calculator.dart';
import 'package:bitscoper_cyberkit/tool_pages/tcp_port_scanner.dart';
import 'package:bitscoper_cyberkit/tool_pages/upnp_scanner.dart';
import 'package:bitscoper_cyberkit/tool_pages/whois_retriever.dart';
import 'package:bitscoper_cyberkit/tool_pages/wifi_details_viewer.dart';
import 'package:bitscoper_cyberkit/version_checker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:permission_guard/permission_guard.dart';
import 'package:url_launcher/url_launcher.dart';

Future<List<Permission>> listStoragePermissions() async {
  final List<Permission> permissions = [];

  if (Platform.isAndroid) {
    final DeviceInfoPlugin deviceInformationPlugin = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInformation =
        await deviceInformationPlugin.androidInfo;
    final int sdkVersion = androidInformation.version.sdkInt;

    if (sdkVersion <= 32) {
      permissions.add(Permission.storage);
    } else if (sdkVersion >= 33) {
      permissions.addAll([
        Permission.audio,
        Permission.photos,
        Permission.videos,
      ]);
    }
  } else if (Platform.isIOS) {
    permissions.add(Permission.mediaLibrary);
  }

  return permissions;
} // FIXME: Consider Other Platforms

class _ToolCardWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Permission?> permissionList;
  final Widget page;

  const _ToolCardWidget({
    required this.icon,
    required this.title,
    required this.permissionList,
    required this.page,
  });

  Widget _permissionGuard(Widget child) {
    if (permissionList.isNotEmpty) {
      Widget current = child;

      for (final Permission permission
          in permissionList.whereType<Permission>()) {
        current = PermissionGuard(
          permission: permission,
          options: const PermissionGuardOptions(
            displayLoader: true,
            requestOnInit: true,
            validStatuses: [
              PermissionStatus.granted,
              PermissionStatus.limited,
              PermissionStatus.provisional,
            ],
          ),
          child: current,
        );
      }

      return current;
    } else {
      return child;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: () {
          try {
            Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return _permissionGuard(page);
                },
              ),
            );
          } catch (error) {
            debugPrint(error.toString());

            showMessageDialog(
              navigatorKey.currentContext!,
              AppLocalizations.of(navigatorKey.currentContext!)!.error,
              error.toString(),
            );
          } finally {}
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 32.0),
              const SizedBox(height: 16.0 * 0.75), // 12.0
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  int _getCrossAxisCount(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    if (width > 1200) {
      return (MediaQuery.of(context).orientation == Orientation.portrait)
          ? 6
          : 8;
    } else if (width > 600) {
      return 4;
    } else {
      return 2;
    }
  }

  Widget _drawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(AppLocalizations.of(context)!.bitscoper_cyberkit),
                      FutureBuilder<String>(
                        future: getLocalVersion(),
                        builder:
                            (
                              BuildContext context,
                              AsyncSnapshot<String> snapshot,
                            ) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text(snapshot.error.toString());
                              } else {
                                return Text(snapshot.data ?? "");
                              }
                            },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.check_version),
                  leading: const Icon(Icons.update_rounded),
                  onTap: () {
                    try {
                      checkVersion(context);
                    } catch (error) {
                      debugPrint(error.toString());

                      showMessageDialog(
                        context,
                        AppLocalizations.of(context)!.error,
                        error.toString(),
                      );
                    } finally {}
                  },
                ),
                const Divider(),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.source_code),
                  leading: const Icon(Icons.code_rounded),
                  onTap: () async {
                    try {
                      final Uri uri = Uri.parse(
                        'https://github.com/bitscoper/bitscoper_cyberkit/',
                      );
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      }
                    } catch (error) {
                      debugPrint(error.toString());

                      showMessageDialog(
                        navigatorKey.currentContext!,
                        AppLocalizations.of(
                          navigatorKey.currentContext!,
                        )!.error,
                        error.toString(),
                      );
                    } finally {}
                  },
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.privacy_policy),
                  leading: const Icon(Icons.privacy_tip_rounded),
                  onTap: () async {
                    try {
                      final Uri uri = Uri.parse(
                        'https://github.com/bitscoper/bitscoper_cyberkit/blob/main/PRIVACY_POLICY.md',
                      );
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      }
                    } catch (error) {
                      debugPrint(error.toString());

                      showMessageDialog(
                        navigatorKey.currentContext!,
                        AppLocalizations.of(
                          navigatorKey.currentContext!,
                        )!.error,
                        error.toString(),
                      );
                    } finally {}
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                AppLocalizations.of(
                  context,
                )!.the_application_displays_error_messages_as_caught,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<(String, IconData, List<Permission?>, StatefulWidget)>>
  _buildTools(BuildContext context) async {
    final List<Permission> storagePermissions = await listStoragePermissions();

    return [
      (
        AppLocalizations.of(
          navigatorKey.currentContext!,
        )!.bluetooth_low_energy_scanner,
        Icons.bluetooth_searching_rounded,
        [
          Permission.bluetooth,
          Permission.bluetoothScan,
          Permission.location,
          Permission.locationWhenInUse,
        ],
        const BluetoothLowEnergyScannerPage(),
      ),
      (
        AppLocalizations.of(navigatorKey.currentContext!)!.ipv4_subnet_scanner,
        Icons.lan_rounded,
        [],
        const IPv4SubnetScannerPage(),
      ),
      (
        AppLocalizations.of(navigatorKey.currentContext!)!.mdns_scanner,
        Icons.stream_rounded,
        [],
        const MDNSScannerPage(),
      ),
      (
        AppLocalizations.of(navigatorKey.currentContext!)!.upnp_scanner,
        Icons.cast_rounded,
        [],
        const UPnPScannerPage(),
      ),
      (
        AppLocalizations.of(navigatorKey.currentContext!)!.route_tracer,
        Icons.track_changes_rounded,
        [],
        const RouteTracerPage(),
      ),
      (
        AppLocalizations.of(navigatorKey.currentContext!)!.tcp_port_scanner,
        Icons.radar_rounded,
        [],
        const TCPPortScannerPage(),
      ),
      (
        AppLocalizations.of(navigatorKey.currentContext!)!.pinger,
        Icons.network_ping_rounded,
        [],
        const PingerPage(),
      ),
      (
        AppLocalizations.of(navigatorKey.currentContext!)!.file_hash_calculator,
        Icons.file_present_rounded,
        storagePermissions,
        const FileHashCalculatorPage(),
      ),
      (
        AppLocalizations.of(
          navigatorKey.currentContext!,
        )!.string_hash_calculator,
        Icons.text_snippet_rounded,
        [],
        const StringHashCalculatorPage(),
      ),
      (
        AppLocalizations.of(navigatorKey.currentContext!)!.cvss_calculator,
        Icons.security_rounded,
        [],
        const CVSSCalculatorPage(),
      ),
      (
        AppLocalizations.of(navigatorKey.currentContext!)!.base_encoder,
        Icons.numbers_rounded,
        [],
        const BaseEncoderPage(),
      ),
      (
        AppLocalizations.of(
          navigatorKey.currentContext!,
        )!.morse_code_translator,
        Icons.text_fields_rounded,
        [],
        const MorseCodeTranslatorPage(),
      ),
      (
        AppLocalizations.of(navigatorKey.currentContext!)!.qr_code_generator,
        Icons.qr_code_rounded,
        storagePermissions,
        const QRCodeGeneratorPage(),
      ),
      (
        AppLocalizations.of(navigatorKey.currentContext!)!.ogp_data_extractor,
        Icons.share_rounded,
        [],
        const OGPDataExtractorPage(),
      ),
      (
        AppLocalizations.of(navigatorKey.currentContext!)!.series_uri_crawler,
        Icons.web_rounded,
        [],
        const SeriesURICrawlerPage(),
      ),
      (
        AppLocalizations.of(navigatorKey.currentContext!)!.dns_record_retriever,
        Icons.dns_rounded,
        [],
        const DNSRecordRetrieverPage(),
      ),
      (
        AppLocalizations.of(navigatorKey.currentContext!)!.whois_retriever,
        Icons.domain_rounded,
        [],
        const WHOISRetrieverPage(),
      ),
      (
        AppLocalizations.of(navigatorKey.currentContext!)!.wifi_details_viewer,
        Icons.network_check_rounded,
        [Permission.location, Permission.locationWhenInUse],
        const WiFiDetailsViewerPage(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(context)!.bitscoper_cyberkit,
      ),
      drawer: _drawer(context),
      body:
          FutureBuilder<
            List<(String, IconData, List<Permission?>, StatefulWidget)>
          >(
            future: _buildTools(context),
            builder:
                (
                  BuildContext context,
                  AsyncSnapshot<
                    List<(String, IconData, List<Permission?>, StatefulWidget)>
                  >
                  snapshot,
                ) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text(snapshot.error.toString()),
                      ),
                    );
                  }

                  final List<
                    (String, IconData, List<Permission?>, StatefulWidget)
                  >
                  tools = snapshot.data!;

                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: MasonryGridView.count(
                      crossAxisCount: _getCrossAxisCount(context),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      itemCount: tools.length,
                      itemBuilder: (BuildContext context, int index) {
                        final (
                          String title,
                          IconData icon,
                          List<Permission?> permissionList,
                          StatefulWidget page,
                        ) = tools[index];

                        return _ToolCardWidget(
                          title: title,
                          icon: icon,
                          permissionList: permissionList,
                          page: page,
                        );
                      },
                    ),
                  );
                },
          ),
    );
  }
}

// TODO: Add Requester for Notification Permission

/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyberkit/commons/application_toolbar.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/commons/permission_requester.dart';
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
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

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

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: () async {
          try {
            if (permissionList.isEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) => page),
              );
              return;
            }

            await requestPermissions(
              permissionList.whereType<Permission>().toList(),
              () {
                try {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => page),
                  );
                } catch (error) {
                  showMessageDialog(
                    AppLocalizations.of(navigatorKey.currentContext!)!.error,
                    error.toString(),
                  );
                } finally {}
              },
            );
          } catch (error) {
            showMessageDialog(
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
              Icon(icon, size: 32),
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

  @override
  Widget build(BuildContext context) {
    final List<(String, IconData, List<Permission?>, StatefulWidget)> tools = [
      (
        AppLocalizations.of(context)!.bluetooth_low_energy_scanner,
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
        AppLocalizations.of(context)!.ipv4_subnet_scanner,
        Icons.lan_rounded,
        [],
        const IPv4SubnetScannerPage(),
      ),
      (
        AppLocalizations.of(context)!.mdns_scanner,
        Icons.stream_rounded,
        [],
        const MDNSScannerPage(),
      ),
      (
        AppLocalizations.of(context)!.upnp_scanner,
        Icons.cast_rounded,
        [],
        const UPnPScannerPage(),
      ),
      (
        AppLocalizations.of(context)!.route_tracer,
        Icons.track_changes_rounded,
        [],
        const RouteTracerPage(),
      ),
      (
        AppLocalizations.of(context)!.tcp_port_scanner,
        Icons.radar_rounded,
        [],
        const TCPPortScannerPage(),
      ),
      (
        AppLocalizations.of(context)!.pinger,
        Icons.network_ping_rounded,
        [],
        const PingerPage(),
      ),
      (
        AppLocalizations.of(context)!.file_hash_calculator,
        Icons.file_present_rounded,
        [
          Permission.audio,
          Permission.mediaLibrary,
          Permission.photos,
          Permission.videos,
        ],
        const FileHashCalculatorPage(),
      ),
      (
        AppLocalizations.of(context)!.string_hash_calculator,
        Icons.text_snippet_rounded,
        [],
        const StringHashCalculatorPage(),
      ),
      (
        AppLocalizations.of(context)!.cvss_calculator,
        Icons.security_rounded,
        [],
        const CVSSCalculatorPage(),
      ),
      (
        AppLocalizations.of(context)!.base_encoder,
        Icons.numbers_rounded,
        [],
        const BaseEncoderPage(),
      ),
      (
        AppLocalizations.of(context)!.morse_code_translator,
        Icons.text_fields_rounded,
        [],
        const MorseCodeTranslatorPage(),
      ),
      (
        AppLocalizations.of(context)!.qr_code_generator,
        Icons.qr_code_rounded,
        [],
        const QRCodeGeneratorPage(),
      ),
      (
        AppLocalizations.of(context)!.ogp_data_extractor,
        Icons.share_rounded,
        [],
        const OGPDataExtractorPage(),
      ),
      (
        AppLocalizations.of(context)!.series_uri_crawler,
        Icons.web_rounded,
        [],
        const SeriesURICrawlerPage(),
      ),
      (
        AppLocalizations.of(context)!.dns_record_retriever,
        Icons.dns_rounded,
        [],
        const DNSRecordRetrieverPage(),
      ),
      (
        AppLocalizations.of(context)!.whois_retriever,
        Icons.domain_rounded,
        [],
        const WHOISRetrieverPage(),
      ),
      (
        AppLocalizations.of(context)!.wifi_details_viewer,
        Icons.network_check_rounded,
        [Permission.location, Permission.locationWhenInUse],
        const WiFiDetailsViewerPage(),
      ),
    ];

    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(context)!.bitscoper_cyberkit,
      ),
      drawer: Drawer(
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
                          future: getVersion(),
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
                                  return Text(snapshot.data ?? '');
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
                        checkVersion();
                      } catch (error) {
                        showMessageDialog(
                          AppLocalizations.of(context)!.error,
                          error.toString(),
                        );
                      } finally {}
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.microsoft_store),
                    leading: const Icon(Icons.shop_2_rounded),
                    onTap: () {
                      try {
                        launchUrl(
                          Uri.parse(
                            'https://apps.microsoft.com/detail/9mv2046tz302',
                          ),
                        );
                      } catch (error) {
                        showMessageDialog(
                          AppLocalizations.of(context)!.error,
                          error.toString(),
                        );
                      } finally {}
                    },
                  ),
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.google_play),
                    leading: const Icon(Icons.shop_rounded),
                    onTap: () {
                      try {
                        launchUrl(
                          Uri.parse(
                            'https://play.google.com/store/apps/details?id=bitscoper.bitscoper_cyberkit',
                          ),
                        );
                      } catch (error) {
                        showMessageDialog(
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
                    onTap: () {
                      try {
                        launchUrl(
                          Uri.parse(
                            'https://github.com/bitscoper/Bitscoper_CyberKit/',
                          ),
                        );
                      } catch (error) {
                        showMessageDialog(
                          AppLocalizations.of(context)!.error,
                          error.toString(),
                        );
                      } finally {}
                    },
                  ),
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.developer),
                    leading: const Icon(Icons.person_rounded),
                    onTap: () {
                      try {
                        launchUrl(Uri.parse('https://bitscoper.dev/'));
                      } catch (error) {
                        showMessageDialog(
                          AppLocalizations.of(context)!.error,
                          error.toString(),
                        );
                      } finally {}
                    },
                  ),
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.privacy_policy),
                    leading: const Icon(Icons.privacy_tip_rounded),
                    onTap: () {
                      try {
                        launchUrl(
                          Uri.parse(
                            'https://bitscoper.dev/Bitscoper_CyberKit/Privacy_Policy.html',
                          ),
                        );
                      } catch (error) {
                        showMessageDialog(
                          AppLocalizations.of(context)!.error,
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
      ),
      body: Padding(
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
      ),
    );
  }
}

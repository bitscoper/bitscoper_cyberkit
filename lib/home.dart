/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyber_toolbox/application_toolbar.dart';
import 'package:bitscoper_cyber_toolbox/base_encoder.dart';
import 'package:bitscoper_cyber_toolbox/dns_record_retriever.dart';
import 'package:bitscoper_cyber_toolbox/file_hash_calculator.dart';
import 'package:bitscoper_cyber_toolbox/l10n/app_localizations.dart';
import 'package:bitscoper_cyber_toolbox/main.dart';
import 'package:bitscoper_cyber_toolbox/mdns_scanner.dart';
import 'package:bitscoper_cyber_toolbox/morse_code_translator.dart';
import 'package:bitscoper_cyber_toolbox/open_graph_protocol_data_extractor.dart';
import 'package:bitscoper_cyber_toolbox/pinger.dart';
import 'package:bitscoper_cyber_toolbox/qr_code_generator.dart';
import 'package:bitscoper_cyber_toolbox/route_tracer.dart';
import 'package:bitscoper_cyber_toolbox/series_uri_crawler.dart';
import 'package:bitscoper_cyber_toolbox/string_hash_calculator.dart';
import 'package:bitscoper_cyber_toolbox/ipv4_subnet_scanner.dart';
import 'package:bitscoper_cyber_toolbox/tcp_port_scanner.dart';
import 'package:bitscoper_cyber_toolbox/version_checker.dart';
import 'package:bitscoper_cyber_toolbox/whois_retriever.dart';
import 'package:bitscoper_cyber_toolbox/wifi_information_viewer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class _ToolCardWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget page;
  const _ToolCardWidget({
    required this.title,
    required this.icon,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) => page),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
  final Function(Locale) changeLocale;
  final Function toggleTheme;
  const HomePage({
    super.key,
    required this.changeLocale,
    required this.toggleTheme,
  });

  int _getCrossAxisCount(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    if (width > 1200) {
      return MediaQuery.of(context).orientation == Orientation.portrait ? 6 : 8;
    } else if (width > 600) {
      return 4;
    } else {
      return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tools = [
      (
        AppLocalizations.of(navigatorKey.currentContext!)!.ipv4_subnet_scanner,
        Icons.lan_rounded,
        const IPv4SubnetScannerPage(),
      ),
      (
        AppLocalizations.of(navigatorKey.currentContext!)!.mdns_scanner,
        Icons.stream_rounded,
        const MDNSScannerPage(),
      ),
      (
        AppLocalizations.of(navigatorKey.currentContext!)!.tcp_port_scanner,
        Icons.radar_rounded,
        const TCPPortScannerPage(),
      ),
      (
        AppLocalizations.of(navigatorKey.currentContext!)!.route_tracer,
        Icons.track_changes_rounded,
        const RouteTracerPage(),
      ),
      (
        AppLocalizations.of(navigatorKey.currentContext!)!.pinger,
        Icons.network_ping_rounded,
        const PingerPage(),
      ),
      (
        AppLocalizations.of(navigatorKey.currentContext!)!.file_hash_calculator,
        Icons.file_present_rounded,
        const FileHashCalculatorPage(),
      ),
      (
        AppLocalizations.of(
          navigatorKey.currentContext!,
        )!.string_hash_calculator,
        Icons.text_snippet_rounded,
        const StringHashCalculatorPage(),
      ),
      (
        AppLocalizations.of(navigatorKey.currentContext!)!.base_encoder,
        Icons.numbers_rounded,
        const BaseEncoderPage(),
      ),
      (
        AppLocalizations.of(
          navigatorKey.currentContext!,
        )!.morse_code_translator,
        Icons.text_fields_rounded,
        const MorseCodeTranslatorPage(),
      ),
      (
        AppLocalizations.of(navigatorKey.currentContext!)!.qr_code_generator,
        Icons.qr_code_rounded,
        const QRCodeGeneratorPage(),
      ),
      (
        AppLocalizations.of(
          navigatorKey.currentContext!,
        )!.open_graph_protocol_data_extractor,
        Icons.share_rounded,
        const OGPDataExtractorPage(),
      ),
      (
        AppLocalizations.of(navigatorKey.currentContext!)!.series_uri_crawler,
        Icons.web_rounded,
        const SeriesURICrawlerPage(),
      ),
      (
        AppLocalizations.of(navigatorKey.currentContext!)!.dns_record_retriever,
        Icons.dns_rounded,
        const DNSRecordRetrieverPage(),
      ),
      (
        AppLocalizations.of(navigatorKey.currentContext!)!.whois_retriever,
        Icons.domain_rounded,
        const WHOISRetrieverPage(),
      ),
      (
        AppLocalizations.of(
          navigatorKey.currentContext!,
        )!.wifi_information_viewer,
        Icons.network_check_rounded,
        const WiFiInformationViewerPage(),
      ),
    ];

    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(
          navigatorKey.currentContext!,
        )!.bitscoper_cyber_toolbox,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(
                      navigatorKey.currentContext!,
                    )!.bitscoper_cyber_toolbox,
                  ),
                  FutureBuilder<String>(
                    future: getVersion(),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
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
              title: Text(
                AppLocalizations.of(
                  navigatorKey.currentContext!,
                )!.change_language,
              ),
              leading: const Icon(Icons.language_rounded),
              onTap: () {
                Locale currentLocale = Localizations.localeOf(context);
                if (currentLocale.languageCode == 'en') {
                  changeLocale(const Locale('bn'));
                } else {
                  changeLocale(const Locale('en'));
                }
              },
            ),
            ListTile(
              title: Text(
                AppLocalizations.of(navigatorKey.currentContext!)!.toggle_theme,
              ),
              leading: const Icon(Icons.dark_mode_rounded),
              onTap: () {
                toggleTheme();
              },
            ),
            ListTile(
              title: Text(
                AppLocalizations.of(
                  navigatorKey.currentContext!,
                )!.check_version,
              ),
              leading: const Icon(Icons.update_rounded),
              onTap: () {
                checkVersion();
              },
            ),
            const Divider(),
            ListTile(
              title: Text(
                AppLocalizations.of(
                  navigatorKey.currentContext!,
                )!.microsoft_store,
              ),
              leading: const Icon(Icons.shop_2_rounded),
              onTap: () {
                launchUrl(
                  Uri.parse('https://apps.microsoft.com/detail/9n6r5lxczxl6'),
                );
              },
            ),
            ListTile(
              title: Text(
                AppLocalizations.of(navigatorKey.currentContext!)!.google_play,
              ),
              leading: const Icon(Icons.shop_rounded),
              onTap: () {
                launchUrl(
                  Uri.parse(
                    'https://play.google.com/store/apps/details?id=bitscoper.bitscoper_cyber_toolbox',
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: Text(
                AppLocalizations.of(navigatorKey.currentContext!)!.source_code,
              ),
              leading: const Icon(Icons.code_rounded),
              onTap: () {
                launchUrl(
                  Uri.parse(
                    'https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/',
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                AppLocalizations.of(navigatorKey.currentContext!)!.developer,
              ),
              leading: const Icon(Icons.person_rounded),
              onTap: () {
                launchUrl(Uri.parse('https://bitscoper.dev/'));
              },
            ),
            ListTile(
              title: Text(
                AppLocalizations.of(
                  navigatorKey.currentContext!,
                )!.privacy_policy,
              ),
              leading: const Icon(Icons.privacy_tip_rounded),
              onTap: () {
                launchUrl(
                  Uri.parse(
                    'https://bitscoper.dev/Bitscoper_Cyber_ToolBox/Privacy_Policy.html',
                  ),
                );
              },
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
            final (title, icon, page) = tools[index];

            return _ToolCardWidget(title: title, icon: icon, page: page);
          },
        ),
      ),
    );
  }
}

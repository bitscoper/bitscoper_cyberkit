/* By Abdullah As-Sadeed */

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:bitscoper_cyber_toolbox/base_encoder.dart';
import 'package:bitscoper_cyber_toolbox/dns_record_retriever.dart';
import 'package:bitscoper_cyber_toolbox/file_hash_calculator.dart';
import 'package:bitscoper_cyber_toolbox/morse_code_translator.dart';
import 'package:bitscoper_cyber_toolbox/open_graph_protocol_data_extractor.dart';
import 'package:bitscoper_cyber_toolbox/pinger.dart';
import 'package:bitscoper_cyber_toolbox/route_tracer.dart';
import 'package:bitscoper_cyber_toolbox/series_uri_crawler.dart';
import 'package:bitscoper_cyber_toolbox/string_hash_calculator.dart';
import 'package:bitscoper_cyber_toolbox/tcp_port_scanner.dart';
import 'package:bitscoper_cyber_toolbox/whois_retriever.dart';

class ToolCard {
  final String title;
  final IconData icon;
  final Widget page;

  ToolCard(
    this.title,
    this.icon,
    this.page,
  );
}

class HomePage extends StatelessWidget {
  final Function(Locale) changeLocale;
  final Function toggleTheme;
  const HomePage(
      {super.key, required this.changeLocale, required this.toggleTheme});

  @override
  Widget build(
    BuildContext context,
  ) {
    final tools = [
      ToolCard(
        AppLocalizations.of(context)!.tcp_port_scanner,
        Icons.network_ping_rounded,
        const TCPPortScannerPage(),
      ),
      ToolCard(
        AppLocalizations.of(context)!.route_tracer,
        Icons.track_changes_rounded,
        const RouteTracerPage(),
      ),
      ToolCard(
        AppLocalizations.of(context)!.pinger,
        Icons.network_ping_rounded,
        const PingerPage(),
      ),
      ToolCard(
        AppLocalizations.of(context)!.file_hash_calculator,
        Icons.file_present_rounded,
        const FileHashCalculatorPage(),
      ),
      ToolCard(
        AppLocalizations.of(context)!.string_hash_calculator,
        Icons.short_text_rounded,
        const StringHashCalculatorPage(),
      ),
      ToolCard(
        AppLocalizations.of(context)!.base_encoder,
        Icons.short_text_rounded,
        const BaseEncoderPage(),
      ),
      ToolCard(
        AppLocalizations.of(context)!.morse_code_translator,
        Icons.short_text_rounded,
        const MorseCodeTranslatorPage(),
      ),
      ToolCard(
        AppLocalizations.of(context)!.open_graph_protocol_data_extractor,
        Icons.share_rounded,
        const OGPDataExtractorPage(),
      ),
      ToolCard(
        AppLocalizations.of(context)!.series_uri_crawler,
        Icons.web_rounded,
        const SeriesURICrawlerPage(),
      ),
      ToolCard(
        AppLocalizations.of(context)!.dns_record_retriever,
        Icons.dns_rounded,
        const DNSRecordRetrieverPage(),
      ),
      ToolCard(
        AppLocalizations.of(context)!.whois_retriever,
        Icons.domain_rounded,
        const WHOISRetrieverPage(),
      ),
    ];

    Widget buildToolCard(
      String title,
      IconData icon,
      Widget page,
    ) {
      return Card(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return page;
                },
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(icon),
                Text(
                  title,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.bitscoper_cyber_toolbox,
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text(
                AppLocalizations.of(context)!.bitscoper_cyber_toolbox,
              ),
            ),
            ListTile(
              title: Text(
                AppLocalizations.of(context)!.change_language,
              ),
              leading: const Icon(Icons.language_rounded),
              onTap: () {
                Locale currentLocale = Localizations.localeOf(context);
                if (currentLocale.languageCode == 'en') {
                  changeLocale(
                    const Locale('bn'),
                  );
                } else {
                  changeLocale(
                    const Locale('en'),
                  );
                }
              },
            ),
            ListTile(
              title: Text(
                AppLocalizations.of(context)!.toggle_theme,
              ),
              leading: const Icon(Icons.dark_mode_rounded),
              onTap: () {
                toggleTheme();
              },
            ),
            ListTile(
              title: Text(
                AppLocalizations.of(context)!.source_code,
              ),
              leading: const Icon(Icons.code_rounded),
              onTap: () {
                launchUrl(
                  Uri.parse(
                      'https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/'),
                );
              },
            ),
            ListTile(
              title: Text(
                AppLocalizations.of(context)!.microsoft_store,
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
                AppLocalizations.of(context)!.google_play,
              ),
              leading: const Icon(Icons.shop_rounded),
              onTap: () {
                launchUrl(
                  Uri.parse(
                      'https://play.google.com/store/apps/details?id=bitscoper.bitscoper_cyber_toolbox'),
                );
              },
            ),
            ListTile(
              title: Text(
                AppLocalizations.of(context)!.developer,
              ),
              leading: const Icon(Icons.person_rounded),
              onTap: () {
                launchUrl(
                  Uri.parse('https://bitscoper.dev/'),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 1200
                ? (MediaQuery.of(context).orientation == Orientation.portrait
                    ? 6
                    : 8)
                : MediaQuery.of(context).size.width > 600
                    ? 4
                    : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 3 / 2,
          ),
          itemCount: tools.length,
          itemBuilder: (BuildContext context, int index) {
            final ToolCard tool = tools[index];

            return buildToolCard(
              tool.title, // title
              tool.icon, // icon
              tool.page, // page widget
            );
          },
        ),
      ),
    );
  }
}

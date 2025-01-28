/* By Abdullah As-Sadeed */

import 'package:flutter/material.dart';
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
  final Function toggleTheme;

  const HomePage({super.key, required this.toggleTheme});

  @override
  Widget build(
    BuildContext context,
  ) {
    final tools = [
      ToolCard(
        'TCP Port Scanner',
        Icons.network_ping_rounded,
        const TCPPortScannerPage(),
      ),
      ToolCard(
        'Route Tracer',
        Icons.track_changes_rounded,
        const RouteTracerPage(),
      ),
      ToolCard(
        'Pinger',
        Icons.network_ping_rounded,
        const PingerPage(),
      ),
      ToolCard(
        'File Hash Calculator',
        Icons.file_present_rounded,
        const FileHashCalculatorPage(),
      ),
      ToolCard(
        'String Hash Calculator',
        Icons.short_text_rounded,
        const StringHashCalculatorPage(),
      ),
      ToolCard(
        'Base Encoder',
        Icons.short_text_rounded,
        const BaseEncoderPage(),
      ),
      ToolCard(
        'Morse Code Translator',
        Icons.short_text_rounded,
        const MorseCodeTranslatorPage(),
      ),
      ToolCard(
        'OGP Data Extractor',
        Icons.share_rounded,
        const OGPDataExtractorPage(),
      ),
      ToolCard(
        'Series URI Crawler',
        Icons.web_rounded,
        const SeriesURICrawlerPage(),
      ),
      ToolCard(
        'DNS Record Retriever',
        Icons.dns_rounded,
        const DNSRecordRetrieverPage(),
      ),
      ToolCard(
        'WHOIS Retriever',
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
        title: const Text('Bitscoper Cyber ToolBox'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const DrawerHeader(
              child: Text('Bitscoper Cyber ToolBox'),
            ),
            ListTile(
              title: const Text('Toggle Theme'),
              leading: const Icon(Icons.dark_mode_rounded),
              onTap: () {
                toggleTheme();
              },
            ),
            ListTile(
              title: const Text('Source Code'),
              leading: const Icon(Icons.code_rounded),
              onTap: () {
                launchUrl(
                  Uri.parse(
                      'https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/'),
                );
              },
            ),
            ListTile(
              title: const Text('Microsoft Store'),
              leading: const Icon(Icons.shop_2_rounded),
              onTap: () {
                launchUrl(
                  Uri.parse('https://apps.microsoft.com/detail/9n6r5lxczxl6'),
                );
              },
            ),
            ListTile(
              title: const Text('Google Play Store'),
              leading: const Icon(Icons.shop_rounded),
              onTap: () {
                launchUrl(
                  Uri.parse(
                      'https://play.google.com/store/apps/details?id=bitscoper.bitscoper_cyber_toolbox'),
                );
              },
            ),
            ListTile(
              title: const Text('Developer'),
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

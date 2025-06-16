/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyber_toolbox/application_toolbar.dart';
import 'package:bitscoper_cyber_toolbox/l10n/app_localizations.dart';
import 'package:bitscoper_cyber_toolbox/main.dart';
import 'package:bitscoper_cyber_toolbox/message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:network_tools_flutter/network_tools_flutter.dart';

class MDNSScannerPage extends StatefulWidget {
  const MDNSScannerPage({super.key});

  @override
  MDNSScannerPageState createState() => MDNSScannerPageState();
}

class MDNSScannerPageState extends State<MDNSScannerPage> {
  bool _isScanning = false;
  List<ActiveHost> hosts = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _scanMDNS() async {
    try {
      setState(() {
        _isScanning = true;
        hosts = [];
      });

      hosts = await MdnsScannerService.instance.searchMdnsDevices();

      setState(() {
        hosts;
      });
    } catch (error) {
      showMessageDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );
    } finally {
      setState(() {
        _isScanning = false;
      });
    }
  }

  Future<Widget> _buildInformationCard(final ActiveHost host) async {
    final MdnsInfo? mdnsInformation = await host.mdnsInfo;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(mdnsInformation!.mdnsName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Name / Target: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: mdnsInformation.mdnsName),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Domain Name / Bundle Identifier: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: mdnsInformation.mdnsDomainName),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Service Target: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: mdnsInformation.mdnsSrvTarget),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Address: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: host.address),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Port: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '${mdnsInformation.mdnsPort}'),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Service Type: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: mdnsInformation.mdnsServiceType),
                ],
              ),
            ),
            SizedBox(height: 8.0),
            Card(
              color: Theme.of(navigatorKey.currentContext!).hoverColor,
              child: ListTile(
                title: Text("PTR Record"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Name: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: mdnsInformation.ptrResourceRecord.name,
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Domain Name: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: mdnsInformation.ptrResourceRecord.domainName,
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Record Type: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                "${mdnsInformation.ptrResourceRecord.resourceRecordType}",
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Validity: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: DateFormat('MMMM dd, yyyy hh:mm:ss a').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                mdnsInformation.txtResourceRecord.validUntil,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              color: Theme.of(navigatorKey.currentContext!).hoverColor,
              child: ListTile(
                title: Text("SRV Record"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Name: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: mdnsInformation.srvResourceRecord.name,
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Target: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: mdnsInformation.srvResourceRecord.target,
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Port: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: "${mdnsInformation.srvResourceRecord.port}",
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Priority: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                "${mdnsInformation.srvResourceRecord.priority}",
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Weight: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: "${mdnsInformation.srvResourceRecord.weight}",
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Record Type: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                "${mdnsInformation.srvResourceRecord.resourceRecordType}",
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Validity: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: DateFormat('MMMM dd, yyyy hh:mm:ss a').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                mdnsInformation.txtResourceRecord.validUntil,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (mdnsInformation.txtResourceRecord.text.isNotEmpty)
              Card(
                color: Theme.of(navigatorKey.currentContext!).hoverColor,
                child: ListTile(
                  title: Text("TXT Record"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Name: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: mdnsInformation.txtResourceRecord.name,
                            ),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Record Type: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  "${mdnsInformation.txtResourceRecord.resourceRecordType}",
                            ),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Validity: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: DateFormat('MMMM dd, yyyy hh:mm:ss a')
                                  .format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                      mdnsInformation
                                          .txtResourceRecord
                                          .validUntil,
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListTile(
                            title: Text("Value"),
                            subtitle: Text(
                              mdnsInformation.txtResourceRecord.text,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(navigatorKey.currentContext!)!.mdns_scanner,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _isScanning
                      ? null
                      : () {
                          _scanMDNS();
                        },
                  child: Text(
                    AppLocalizations.of(navigatorKey.currentContext!)!.scan,
                  ),
                ),
                ElevatedButton(
                  onPressed: _isScanning
                      ? () {
                          setState(() {
                            _isScanning = false;
                          });
                        }
                      : null,
                  child: Text(
                    AppLocalizations.of(navigatorKey.currentContext!)!.stop,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            if (_isScanning)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[Center(child: CircularProgressIndicator())],
              ),
            FutureBuilder<List<Widget>>(
              future: Future.wait(hosts.map(_buildInformationCard)),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: snapshot.data!,
                      );
                    } else if (snapshot.hasError) {
                      showMessageDialog(
                        AppLocalizations.of(
                          navigatorKey.currentContext!,
                        )!.error,
                        snapshot.error.toString(),
                      );

                      return const SizedBox();
                    } else {
                      return const SizedBox();
                    }
                  },
            ),
          ],
        ),
      ),
    );
  }
}

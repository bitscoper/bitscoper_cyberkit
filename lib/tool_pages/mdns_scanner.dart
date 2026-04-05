/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyberkit/commons/application_toolbar.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:network_tools_flutter/network_tools_flutter.dart';

class MDNSScannerPage extends StatefulWidget {
  const MDNSScannerPage({super.key});

  @override
  MDNSScannerPageState createState() {
    return MDNSScannerPageState();
  }
}

class MDNSScannerPageState extends State<MDNSScannerPage> {
  bool _isScanning = false;
  List<ActiveHost> hosts = [];

  @override
  void initState() {
    super.initState();
  }

  void _scan() async {
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
      debugPrint(error.toString());

      showMessageDialog(
        navigatorKey.currentContext!,
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );
    } finally {
      _isScanning = false;
    }
  }

  void _stop(BuildContext context) {
    try {
      setState(() {
        _isScanning = false;
      });
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(
        context,
        AppLocalizations.of(context)!.error,
        error.toString(),
      );
    } finally {}
  }

  Widget _form(BuildContext context) {
    return Form(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ElevatedButton(
            onPressed: _isScanning ? null : _scan,
            child: Text(AppLocalizations.of(context)!.scan),
          ),
          ElevatedButton(
            onPressed: _isScanning
                ? () {
                    _stop(context);
                  }
                : null,
            child: Text(AppLocalizations.of(context)!.stop),
          ),
        ],
      ),
    );
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
                    text:
                        "${AppLocalizations.of(navigatorKey.currentContext!)!.name_or_target}: ",
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
                    text:
                        "${AppLocalizations.of(navigatorKey.currentContext!)!.domain_name_or_bundle_identifier}: ",
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
                    text:
                        "${AppLocalizations.of(navigatorKey.currentContext!)!.service_target}: ",
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
                    text:
                        "${AppLocalizations.of(navigatorKey.currentContext!)!.address}: ",
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
                    text:
                        "${AppLocalizations.of(navigatorKey.currentContext!)!.port}: ",
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
                    text:
                        "${AppLocalizations.of(navigatorKey.currentContext!)!.service_type}: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: mdnsInformation.mdnsServiceType),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            Card(
              color: Theme.of(navigatorKey.currentContext!).hoverColor,
              child: ListTile(
                title: Text(
                  AppLocalizations.of(navigatorKey.currentContext!)!.ptr_record,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                "${AppLocalizations.of(navigatorKey.currentContext!)!.name}: ",
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
                            text:
                                "${AppLocalizations.of(navigatorKey.currentContext!)!.domain_name}: ",
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
                            text:
                                "${AppLocalizations.of(navigatorKey.currentContext!)!.record_type}: ",
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
                            text:
                                "${AppLocalizations.of(navigatorKey.currentContext!)!.validity}: ",
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
                title: Text(
                  AppLocalizations.of(navigatorKey.currentContext!)!.srv_record,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                "${AppLocalizations.of(navigatorKey.currentContext!)!.name}: ",
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
                            text:
                                "${AppLocalizations.of(navigatorKey.currentContext!)!.target}: ",
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
                            text:
                                "${AppLocalizations.of(navigatorKey.currentContext!)!.port}: ",
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
                            text:
                                "${AppLocalizations.of(navigatorKey.currentContext!)!.priority}: ",
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
                            text:
                                "${AppLocalizations.of(navigatorKey.currentContext!)!.weight}: ",
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
                            text:
                                "${AppLocalizations.of(navigatorKey.currentContext!)!.record_type}: ",
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
                            text:
                                "${AppLocalizations.of(navigatorKey.currentContext!)!.validity}: ",
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
                  title: Text(
                    AppLocalizations.of(
                      navigatorKey.currentContext!,
                    )!.txt_record,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "${AppLocalizations.of(navigatorKey.currentContext!)!.name}: ",
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
                              text:
                                  "${AppLocalizations.of(navigatorKey.currentContext!)!.record_type}: ",
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
                              text:
                                  "${AppLocalizations.of(navigatorKey.currentContext!)!.validity}: ",
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
                            title: Text(
                              AppLocalizations.of(
                                navigatorKey.currentContext!,
                              )!.value,
                            ),
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

  Widget _resultWrapper() {
    return FutureBuilder<List<Widget>>(
      future: Future.wait(hosts.map(_buildInformationCard)),
      builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: snapshot.data!,
          );
        } else if (snapshot.hasError) {
          showMessageDialog(
            context,
            AppLocalizations.of(context)!.error,
            snapshot.error.toString(),
          );

          return const SizedBox.shrink();
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(context)!.mdns_scanner,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _form(context),
            const SizedBox(height: 16.0),
            if (_isScanning) Center(child: CircularProgressIndicator()),
            _resultWrapper(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyberkit/commons/application_toolbar.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:flutter/material.dart';
import 'package:network_tools_flutter/network_tools_flutter.dart';

class IPv4SubnetScannerPage extends StatefulWidget {
  const IPv4SubnetScannerPage({super.key});

  @override
  IPv4SubnetScannerPageState createState() => IPv4SubnetScannerPageState();
}

class IPv4SubnetScannerPageState extends State<IPv4SubnetScannerPage> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _subnetEditingController =
      TextEditingController();

  bool _isScanning = false;
  Set<ActiveHost> _discoveredHosts = <ActiveHost>{};

  Future<void> _scanSubnet() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _isScanning = true;
          _discoveredHosts.clear();
        });

        HostScannerService.instance
            .getAllPingableDevices(
              _subnetEditingController.text.trim(),
              firstHostId: 1,
              lastHostId: 254,
              resultsInAddressAscendingOrder: true,
            )
            .listen(
              (ActiveHost discoveredHost) {
                setState(() {
                  _discoveredHosts.add(discoveredHost);
                });
              },
              onDone: () {
                setState(() {
                  _isScanning = false;
                });
              },
            );
      } catch (error) {
        showMessageDialog(
          AppLocalizations.of(navigatorKey.currentContext!)!.error,
          error.toString(),
        );

        setState(() {
          _isScanning = false;
        });
      } finally {}
    }
  }

  @override
  void dispose() {
    _subnetEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(
          navigatorKey.currentContext!,
        )!.ipv4_subnet_scanner,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _subnetEditingController,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: AppLocalizations.of(
                        navigatorKey.currentContext!,
                      )!.an_ipv4_subnet,
                      hintText: "1.1.1",
                    ),
                    showCursor: true,
                    maxLines: 1,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(
                          navigatorKey.currentContext!,
                        )!.enter_an_ipv4_subnet;
                      }
                      return null;
                    },
                    onChanged: (String value) {},
                    onFieldSubmitted: (String value) {
                      _scanSubnet();
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: _isScanning
                            ? null
                            : () {
                                _scanSubnet();
                              },
                        child: Text(
                          AppLocalizations.of(
                            navigatorKey.currentContext!,
                          )!.scan,
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
                          AppLocalizations.of(
                            navigatorKey.currentContext!,
                          )!.stop,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_isScanning)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 16.0),
                  const Center(child: CircularProgressIndicator()),
                ],
              ),
            SizedBox(height: 16.0),
            Center(
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: <Widget>[
                  if (_discoveredHosts.isNotEmpty)
                    ..._discoveredHosts.map((ActiveHost discoveredHost) {
                      return Chip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          right: 4.0,
                          bottom: 8.0,
                          left: 4.0,
                        ),
                        label: Text(discoveredHost.address.toString()),
                      );
                    }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

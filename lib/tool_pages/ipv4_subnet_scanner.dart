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
  IPv4SubnetScannerPageState createState() {
    return IPv4SubnetScannerPageState();
  }
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

  String? _subnetFieldValidator(String? value) {
    if ((value == null) || value.isEmpty) {
      return AppLocalizations.of(
        navigatorKey.currentContext!,
      )!.enter_an_ipv4_subnet;
    } else {
      return null;
    }
  }

  Future<void> _scan() async {
    try {
      if (_formKey.currentState!.validate()) {
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
      }
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );

      setState(() {
        _isScanning = false;
      });
    } finally {}
  }

  void _stop() {
    try {
      setState(() {
        _isScanning = false;
      });
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );
    } finally {}
  }

  Widget _form() {
    return Form(
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
            validator: _subnetFieldValidator,
            onChanged: (String value) {},
            onFieldSubmitted: (String value) {
              _scan();
            },
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ElevatedButton(
                onPressed: _isScanning ? null : _scan,
                child: Text(
                  AppLocalizations.of(navigatorKey.currentContext!)!.scan,
                ),
              ),
              ElevatedButton(
                onPressed: _isScanning ? _stop : null,
                child: Text(
                  AppLocalizations.of(navigatorKey.currentContext!)!.stop,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _progressIndicator() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 16.0),
        Center(child: CircularProgressIndicator()),
      ],
    );
  }

  Widget _resultWrapper() {
    return Center(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(context)!.ipv4_subnet_scanner,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _form(),
            if (_isScanning) _progressIndicator(),
            const SizedBox(height: 16.0),
            _resultWrapper(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subnetEditingController.dispose();

    super.dispose();
  }
}

/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyberkit/commons/application_toolbar.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/material.dart';

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
  final Set<Ping> _activePings = <Ping>{};

  bool _isScanning = false;
  final Set<String> _discoveredHosts = <String>{};

  String? _subnetFieldValidator(BuildContext context, String? value) {
    if ((value == null) || value.isEmpty) {
      return AppLocalizations.of(context)!.enter_an_ipv4_subnet;
    } else {
      return null;
    }
  }

  Future<void> _scan(BuildContext context) async {
    try {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isScanning = true;
          _discoveredHosts.clear();
        });

        await Future.wait(
          List<int>.generate(254, (int index) {
            return index++;
          }).map((int hostId) {
            return _ping('${_subnetEditingController.text.trim()}.$hostId');
          }),
        );
      }
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(
        navigatorKey.currentContext!,
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );
    } finally {
      setState(() {
        _isScanning = false;
      });
    }
  }

  Future<void> _ping(String host) async {
    if (_isScanning) {
      try {
        final Ping ping = Ping(
          host,
          ipVersion: IpVersion.ipv4,
          nat64Synthesis: true,
          count: 1,
        );

        _activePings.add(ping);

        await for (final PingEvent event in ping.stream) {
          if (_isScanning) {
            if (event case PingResponse(ip: final String? ipAddress)) {
              if (ipAddress != null) {
                setState(() {
                  _discoveredHosts.add(ipAddress);
                });
              }
            }
          } else {
            break;
          }
        }

        _activePings.remove(ping);
      } catch (error) {
        debugPrint(error.toString());

        showMessageDialog(
          navigatorKey.currentContext!,
          AppLocalizations.of(navigatorKey.currentContext!)!.error,
          error.toString(),
        );
      } finally {}
    } else {
      return;
    }
  }

  Future<void> _stop(BuildContext context) async {
    try {
      await Future.wait(
        List<Ping>.from(_activePings).map((Ping ping) {
          return ping.stop();
        }),
      );

      _activePings.clear();

      setState(() {
        _isScanning = false;
      });
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(
        navigatorKey.currentContext!,
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );
    } finally {}
  }

  Widget _form(BuildContext context) {
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
              labelText: AppLocalizations.of(context)!.an_ipv4_subnet,
              hintText: "1.1.1",
            ),
            showCursor: true,
            maxLines: 1,
            validator: (String? value) {
              return _subnetFieldValidator(context, value);
            },
            onChanged: (String value) {},
            onFieldSubmitted: (String value) {
              _scan(context);
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
                        _scan(context);
                      },
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
            ..._discoveredHosts.map((String discoveredHost) {
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
                label: Text(discoveredHost),
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
            _form(context),
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

    for (final Ping ping in _activePings) {
      ping.stop();
    }

    super.dispose();
  }
}

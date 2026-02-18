/* By Abdullah As-Sadeed */

import 'dart:io';
import 'package:bitscoper_cyberkit/commons/application_toolbar.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:flutter/material.dart';
import 'package:upnp_client/upnp_client.dart';

class UPnPScannerPage extends StatefulWidget {
  const UPnPScannerPage({super.key});

  @override
  UPnPScannerPageState createState() => UPnPScannerPageState();
}

class UPnPScannerPageState extends State<UPnPScannerPage> {
  DeviceDiscoverer? _deviceDiscoverer;

  bool _isScanning = false;
  final List<Device> _devices = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _stopScan() async {
    try {
      _deviceDiscoverer?.stop();
    } catch (error) {
      debugPrint(error.toString());

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

  String _extractName(String dump) {
    try {
      final RegExp regex = RegExp(r'friendlyName:\s*([^,\n}]+)');
      final Match? match = regex.firstMatch(dump);

      return match?.group(1)?.trim() ??
          '${AppLocalizations.of(context)!.unknown} ${AppLocalizations.of(context)!.device}';
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );

      return AppLocalizations.of(context)!.unknown;
    } finally {}
  }

  String _extractIPAddress(String dump) {
    try {
      final RegExp regex = RegExp(r'url:\s*(https?:\/\/[^\/\s]+)');
      final Match? match = regex.firstMatch(dump);

      if (match == null) {
        return AppLocalizations.of(context)!.unknown;
      }

      final Uri uri = Uri.parse(match.group(1)!);
      return uri.host;
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );

      return AppLocalizations.of(context)!.unknown;
    } finally {}
  }

  String _formatDump(String dump) {
    try {
      final StringBuffer stringBuffer = StringBuffer();
      int indent = 0;

      for (int i = 0; i < dump.length; i++) {
        final String character = dump[i];

        if ((character == '{') || (character == '[')) {
          stringBuffer.writeln(character);
          indent++;
          stringBuffer.write('  ' * indent);
        } else if ((character == '}') || (character == ']')) {
          stringBuffer.writeln();
          indent--;
          stringBuffer.write('  ' * indent);
          stringBuffer.write(character);
        } else if (character == ',') {
          stringBuffer.writeln(',');
          stringBuffer.write('  ' * indent);
        } else {
          stringBuffer.write(character);
        }
      }

      return stringBuffer
          .toString()
          .split('\n')
          .where((String line) => line.trim().isNotEmpty)
          .join('\n');
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );

      return dump;
    } finally {}
  }

  Widget _buildDeviceCard(final Device device) {
    final String dump = device.toString();
    final String name = _extractName(dump);
    final String host = _extractIPAddress(dump);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "${AppLocalizations.of(context)!.ip_address}: ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: host),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Card(
                color: Theme.of(context).hoverColor,
                elevation: 1.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  subtitle: SelectableText(
                    _formatDump(dump),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
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
    _deviceDiscoverer?.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(context)!.upnp_scanner,
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
                      : () async {
                          try {
                            setState(() {
                              _isScanning = true;
                              _devices.clear();
                            });

                            _deviceDiscoverer = DeviceDiscoverer();
                            await _deviceDiscoverer!.start(
                              addressTypes: <InternetAddressType>[
                                InternetAddressType.IPv4,
                                InternetAddressType.IPv6,
                              ],
                            );
                            final List<Device> devices =
                                await _deviceDiscoverer!.getDevices();

                            if (devices.isNotEmpty) {
                              setState(() {
                                for (final Device device in devices) {
                                  if (!_devices.contains(device)) {
                                    _devices.add(device);
                                  }
                                }
                              });
                            }
                          } catch (error) {
                            debugPrint(error.toString());

                            showMessageDialog(
                              AppLocalizations.of(
                                navigatorKey.currentContext!,
                              )!.error,
                              error.toString(),
                            );
                          } finally {
                            await _stopScan();
                          }
                        },
                  child: Text(AppLocalizations.of(context)!.scan),
                ),
                ElevatedButton(
                  onPressed: _isScanning ? _stopScan : null,
                  child: Text(AppLocalizations.of(context)!.stop),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            if (_isScanning) Center(child: CircularProgressIndicator()),
            if (_devices.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _devices.map(_buildDeviceCard).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

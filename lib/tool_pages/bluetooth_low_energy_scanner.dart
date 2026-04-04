/* By Abdullah As-Sadeed */

import 'dart:async';
import 'package:bitscoper_cyberkit/commons/application_toolbar.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothLowEnergyScannerPage extends StatefulWidget {
  const BluetoothLowEnergyScannerPage({super.key});

  @override
  BluetoothLowEnergyScannerPageState createState() {
    return BluetoothLowEnergyScannerPageState();
  }
}

class BluetoothLowEnergyScannerPageState
    extends State<BluetoothLowEnergyScannerPage> {
  StreamSubscription<List<ScanResult>>? _scanSubscription;

  bool _isScanning = false;
  final List<ScanResult> _scanResults = [];

  @override
  void initState() {
    super.initState();
  }

  void _scan() async {
    try {
      setState(() {
        _isScanning = true;
        _scanResults.clear();
      });

      await FlutterBluePlus.adapterState.where((BluetoothAdapterState state) {
        return (state == BluetoothAdapterState.on);
      }).first;

      _scanSubscription = FlutterBluePlus.onScanResults.listen(
        (List<ScanResult> scanResults) {
          try {
            if (scanResults.isNotEmpty) {
              setState(() {
                for (final ScanResult scanResult in scanResults) {
                  if (!_scanResults.any((ScanResult result_) {
                    return (result_.device.remoteId ==
                        scanResult.device.remoteId);
                  })) {
                    _scanResults.add(scanResult);
                  }
                }
              });
            }
          } catch (error) {
            debugPrint(error.toString());

            showMessageDialog(
              navigatorKey.currentContext!,
              AppLocalizations.of(navigatorKey.currentContext!)!.error,
              error.toString(),
            );
          } finally {}
        },
        onError: (error) {
          showMessageDialog(
            navigatorKey.currentContext!,
            AppLocalizations.of(navigatorKey.currentContext!)!.error,
            error.toString(),
          );
        },
      );

      FlutterBluePlus.cancelWhenScanComplete(_scanSubscription!);

      await FlutterBluePlus.startScan(
        androidCheckLocationServices: true,
        androidUsesFineLocation: true,
        androidScanMode: AndroidScanMode.lowLatency,
        continuousUpdates: true,
      );

      await FlutterBluePlus.isScanning.where((bool value) {
        return (value == false);
      }).first;
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

  void _stop() async {
    try {
      await FlutterBluePlus.stopScan();
      await _scanSubscription?.cancel();
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
            onPressed: _isScanning ? _stop : null,
            child: Text(AppLocalizations.of(context)!.stop),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceCard(BuildContext context, final ScanResult scanResult) {
    final BluetoothDevice device = scanResult.device;
    final AdvertisementData advertisement = scanResult.advertisementData;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          advertisement.advName.isNotEmpty
              ? advertisement.advName
              : AppLocalizations.of(context)!.unknown,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "${AppLocalizations.of(context)!.address}: ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: device.remoteId.str),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "${AppLocalizations.of(context)!.rssi}: ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: "${scanResult.rssi} dBm"),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "${AppLocalizations.of(context)!.connectable}: ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: advertisement.connectable.toString()),
                ],
              ),
            ),
            if (advertisement.serviceUuids.isNotEmpty)
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "${AppLocalizations.of(context)!.service_type}: ",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: advertisement.serviceUuids.join(", ")),
                  ],
                ),
              ),
            if (advertisement.manufacturerData.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Card(
                  color: Theme.of(context).hoverColor,
                  child: ListTile(
                    title: Text(AppLocalizations.of(context)!.manufacturer),
                    subtitle: Text(
                      advertisement.manufacturerData.entries
                          .map((MapEntry<int, List<int>> entry) {
                            return "0x${entry.key.toRadixString(16)}: ${entry.value}";
                          })
                          .join("\n"),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _resultColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _scanResults.map((ScanResult scanResult) {
        return _buildDeviceCard(context, scanResult);
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(context)!.bluetooth_le_scanner,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _form(context),
            const SizedBox(height: 16.0),
            if (_isScanning) const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 16.0),
            if (_scanResults.isNotEmpty) _resultColumn(context),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    _scanSubscription?.cancel();

    super.dispose();
  }
}

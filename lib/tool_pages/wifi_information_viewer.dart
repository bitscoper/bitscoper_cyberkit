/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyberkit/commons/application_toolbar.dart';
import 'package:bitscoper_cyberkit/commons/copy_to_clipboard.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';

class WiFiInformationViewerPage extends StatefulWidget {
  const WiFiInformationViewerPage({super.key});

  @override
  WiFiInformationViewerPageState createState() =>
      WiFiInformationViewerPageState();
}

class WiFiInformationViewerPageState extends State<WiFiInformationViewerPage> {
  @override
  void initState() {
    super.initState();

    _loadWiFiInformation();
  }

  List<ConnectivityResult>? networkConnectivityResult;
  final NetworkInfo _wifiInformation = NetworkInfo();

  String? _ssid,
      _bssid,
      _ipAddress,
      _ipV6Address,
      _subnetMask,
      _broadcast,
      _gatewayIPAddress;

  Future<void> _loadWiFiInformation() async {
    try {
      networkConnectivityResult = await (Connectivity().checkConnectivity());

      setState(() {
        networkConnectivityResult;
      });

      if (networkConnectivityResult!.contains(ConnectivityResult.wifi)) {
        _ssid = await _wifiInformation.getWifiName();
        _bssid = await _wifiInformation.getWifiBSSID();
        _ipAddress = await _wifiInformation.getWifiIP();
        _ipV6Address = await _wifiInformation.getWifiIPv6();
        _subnetMask = await _wifiInformation.getWifiSubmask();
        _broadcast = await _wifiInformation.getWifiBroadcast();
        _gatewayIPAddress = await _wifiInformation.getWifiGatewayIP();

        setState(() {
          _ssid;
          _bssid;
          _ipAddress;
          _ipV6Address;
          _subnetMask;
          _broadcast;
          _gatewayIPAddress;
        });
      }
    } catch (error) {
      showMessageDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );
    } finally {}
  }

  Widget _informationCard(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        child: ListTile(
          title: Text(label),
          subtitle: Text(value ?? "Unavailable"),
          trailing: value == null
              ? null
              : IconButton(
                  icon: const Icon(Icons.copy_rounded),
                  onPressed: () {
                    copyToClipboard(label, value);
                  },
                  tooltip: AppLocalizations.of(
                    navigatorKey.currentContext!,
                  )!.copy_to_clipboard,
                ),
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
        title: AppLocalizations.of(
          navigatorKey.currentContext!,
        )!.wifi_information_viewer,
      ),
      body: networkConnectivityResult == null
          ? Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            )
          : networkConnectivityResult!.contains(ConnectivityResult.wifi)
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _informationCard(
                    AppLocalizations.of(
                      navigatorKey.currentContext!,
                    )!.service_set_identifier_ssid,
                    _ssid,
                  ),
                  _informationCard(
                    AppLocalizations.of(
                      navigatorKey.currentContext!,
                    )!.basic_service_set_identifier_bssid,
                    _bssid,
                  ),
                  _informationCard(
                    AppLocalizations.of(
                      navigatorKey.currentContext!,
                    )!.internet_protocol_version_4_ipv4_address,
                    _ipAddress,
                  ),
                  _informationCard(
                    AppLocalizations.of(
                      navigatorKey.currentContext!,
                    )!.internet_protocol_version_6_ipv6_address,
                    _ipV6Address,
                  ),
                  _informationCard(
                    AppLocalizations.of(
                      navigatorKey.currentContext!,
                    )!.subnet_mask,
                    _subnetMask,
                  ),
                  _informationCard(
                    AppLocalizations.of(
                      navigatorKey.currentContext!,
                    )!.broadcast_address,
                    _broadcast,
                  ),
                  _informationCard(
                    AppLocalizations.of(navigatorKey.currentContext!)!.gateway,
                    _gatewayIPAddress,
                  ),
                ],
              ),
            )
          : Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  AppLocalizations.of(
                    navigatorKey.currentContext!,
                  )!.wifi_is_disconnected,
                ),
              ),
            ),
    );
  }
}

/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyberkit/commons/application_toolbar.dart';
import 'package:bitscoper_cyberkit/commons/copy_to_clipboard.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';

class WiFiDetailsViewerPage extends StatefulWidget {
  const WiFiDetailsViewerPage({super.key});

  @override
  WiFiDetailsViewerPageState createState() => WiFiDetailsViewerPageState();
}

class WiFiDetailsViewerPageState extends State<WiFiDetailsViewerPage> {
  @override
  void initState() {
    super.initState();

    _loadWiFiDetails();
  }

  List<ConnectivityResult>? networkConnectivityResult;
  final NetworkInfo _wifiDetails = NetworkInfo();

  String? _ssid,
      _bssid,
      _ipAddress,
      _ipV6Address,
      _subnetMask,
      _broadcast,
      _gatewayIPAddress;

  Future<void> _loadWiFiDetails() async {
    try {
      networkConnectivityResult = await (Connectivity().checkConnectivity());

      setState(() {
        networkConnectivityResult;
      });

      if (networkConnectivityResult!.contains(ConnectivityResult.wifi)) {
        _ssid = await _wifiDetails.getWifiName();
        _bssid = await _wifiDetails.getWifiBSSID();
        _ipAddress = await _wifiDetails.getWifiIP();
        _ipV6Address = await _wifiDetails.getWifiIPv6();
        _subnetMask = await _wifiDetails.getWifiSubmask();
        _broadcast = await _wifiDetails.getWifiBroadcast();
        _gatewayIPAddress = await _wifiDetails.getWifiGatewayIP();

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
      debugPrint(error.toString());

      showMessageDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );
    } finally {}
  }

  Widget _detailsCard(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        child: ListTile(
          title: Text(label),
          subtitle: Text(value ?? "Unavailable"),
          trailing: (value == null)
              ? null
              : IconButton(
                  icon: const Icon(Icons.copy_rounded),
                  onPressed: () {
                    try {
                      copyToClipboard(label, value);
                    } catch (error) {
                      debugPrint(error.toString());

                      showMessageDialog(
                        AppLocalizations.of(context)!.error,
                        error.toString(),
                      );
                    } finally {}
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
        title: AppLocalizations.of(context)!.wifi_details_viewer,
      ),
      body: (networkConnectivityResult == null)
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
                  _detailsCard(
                    AppLocalizations.of(context)!.service_set_identifier_ssid,
                    _ssid,
                  ),
                  _detailsCard(
                    AppLocalizations.of(
                      context,
                    )!.basic_service_set_identifier_bssid,
                    _bssid,
                  ),
                  _detailsCard(
                    AppLocalizations.of(
                      context,
                    )!.internet_protocol_version_4_ipv4_address,
                    _ipAddress,
                  ),
                  _detailsCard(
                    AppLocalizations.of(
                      context,
                    )!.internet_protocol_version_6_ipv6_address,
                    _ipV6Address,
                  ),
                  _detailsCard(
                    AppLocalizations.of(context)!.subnet_mask,
                    _subnetMask,
                  ),
                  _detailsCard(
                    AppLocalizations.of(context)!.broadcast_address,
                    _broadcast,
                  ),
                  _detailsCard(
                    AppLocalizations.of(context)!.gateway,
                    _gatewayIPAddress,
                  ),
                ],
              ),
            )
          : Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: Text(AppLocalizations.of(context)!.wifi_is_disconnected),
              ),
            ),
    );
  }
}

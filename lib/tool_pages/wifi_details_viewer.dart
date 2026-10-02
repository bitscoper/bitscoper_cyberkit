/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyberkit/commons/application_toolbar.dart';
import 'package:bitscoper_cyberkit/commons/copy_to_clipboard.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:network_info_plus/network_info_plus.dart';

final Provider<NetworkInfo> networkInformationProvider = Provider<NetworkInfo>((
  Ref ref,
) {
  return NetworkInfo();
});

final FutureProvider<Map<String, String?>> wifiDetailsProvider =
    FutureProvider.autoDispose<Map<String, String?>>((Ref ref) async {
      try {
        final NetworkInfo networkInformation = ref.read<NetworkInfo>(
          networkInformationProvider,
        );

        final List<ConnectivityResult> networkConnectivityResult =
            await Connectivity().checkConnectivity();

        Map<String, String?> wifiDetails = <String, String?>{};

        if (networkConnectivityResult.contains(ConnectivityResult.wifi)) {
          wifiDetails['ssid'] = await networkInformation.getWifiName();
          wifiDetails['bssid'] = await networkInformation.getWifiBSSID();
          wifiDetails['ipAddress'] = await networkInformation.getWifiIP();
          wifiDetails['ipV6Address'] = await networkInformation.getWifiIPv6();
          wifiDetails['subnetMask'] = await networkInformation.getWifiSubmask();
          wifiDetails['broadcast'] = await networkInformation
              .getWifiBroadcast();
          wifiDetails['gatewayIPAddress'] = await networkInformation
              .getWifiGatewayIP();
        }

        return wifiDetails;
      } catch (error) {
        debugPrint(error.toString());

        showMessageDialog(
          navigatorKey.currentContext!,
          AppLocalizations.of(navigatorKey.currentContext!)!.error,
          error.toString(),
        );

        return <String, String?>{
          AppLocalizations.of(navigatorKey.currentContext!)!.error: error
              .toString(),
        };
      } finally {}
    });

class WiFiDetailsViewerPage extends ConsumerWidget {
  const WiFiDetailsViewerPage({super.key});

  Widget _progressIndicator() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _wifiDetailsCard(BuildContext context, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        child: ListTile(
          title: Text(label),
          subtitle: Text(value ?? "Unavailable"),
          trailing: (value == null)
              ? null
              : IconButton(
                  icon: const Icon(Icons.copy_rounded),
                  onPressed: () {
                    copyToClipboard(context, label, value);
                  },
                  tooltip: AppLocalizations.of(context)!.copy_to_clipboard,
                ),
        ),
      ),
    );
  }

  Widget _wifiDetailsView(BuildContext context, Map<String, String?> data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _wifiDetailsCard(
            context,
            AppLocalizations.of(context)!.service_set_identifier_ssid,
            data['ssid'],
          ),
          _wifiDetailsCard(
            context,
            AppLocalizations.of(context)!.basic_service_set_identifier_bssid,
            data['bssid'],
          ),
          _wifiDetailsCard(
            context,
            AppLocalizations.of(context)!
                .internet_protocol_version_4_ipv4_address,
            data['ipAddress'],
          ),
          _wifiDetailsCard(
            context,
            AppLocalizations.of(context)!
                .internet_protocol_version_6_ipv6_address,
            data['ipV6Address'],
          ),
          _wifiDetailsCard(
            context,
            AppLocalizations.of(context)!.subnet_mask,
            data['subnetMask'],
          ),
          _wifiDetailsCard(
            context,
            AppLocalizations.of(context)!.broadcast_address,
            data['broadcast'],
          ),
          _wifiDetailsCard(
            context,
            AppLocalizations.of(context)!.gateway,
            data['gatewayIPAddress'],
          ),
        ],
      ),
    );
  }

  Widget _wifiDisconnectionNotice(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Text(AppLocalizations.of(context)!.wifi_is_disconnected),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Map<String, String?>> wifiDetailsAsync = ref
        .watch<AsyncValue<Map<String, String?>>>(wifiDetailsProvider);

    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(context)!.wifi_details_viewer,
      ),
      body: wifiDetailsAsync.when<Widget?>(
        data: (Map<String, String?> data) {
          if (data.containsKey('error')) {
            showMessageDialog(
              navigatorKey.currentContext!,
              AppLocalizations.of(navigatorKey.currentContext!)!.error,
              data['error']!,
            );

            return _progressIndicator();
          }

          if (data['ssid'] != null) {
            return _wifiDetailsView(context, data);
          } else {
            return _wifiDisconnectionNotice(context);
          }
        },
        loading: () {
          return _progressIndicator();
        },
        error: (Object error, StackTrace stackTrace) {
          debugPrint(error.toString());

          showMessageDialog(
            navigatorKey.currentContext!,
            AppLocalizations.of(navigatorKey.currentContext!)!.error,
            error.toString(),
          );

          return _progressIndicator();
        },
      ),
    );
  }
}

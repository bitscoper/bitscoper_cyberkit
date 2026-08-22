/* By Abdullah As-Sadeed */

import 'dart:async';

import 'package:bitscoper_cyberkit/commons/application_toolbar.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multicast_dns/multicast_dns.dart';

class MDNSScannerPage extends StatefulWidget {
  const MDNSScannerPage({super.key});

  @override
  MDNSScannerPageState createState() {
    return MDNSScannerPageState();
  }
}

class MDNSScannerPageState extends State<MDNSScannerPage> {
  final MDnsClient _client = MDnsClient();

  bool _isScanning = false;
  final List<
    ({
      List<IPAddressResourceRecord> ipAddressResourceRecords,
      PtrResourceRecord pointerResourceRecord,
      SrvResourceRecord serviceResourceRecord,
      TxtResourceRecord? textResourceRecord,
    })
  >
  _hosts = [];

  @override
  void initState() {
    super.initState();
  }

  Future<List<PtrResourceRecord>?> _findServiceTypes(MDnsClient client) async {
    try {
      final List<PtrResourceRecord> serviceTypes = <PtrResourceRecord>[];

      await for (final PtrResourceRecord pointerResourceRecord
          in client.lookup<PtrResourceRecord>(
            ResourceRecordQuery.serverPointer('_services._dns-sd._udp.local'),
          )) {
        if (!serviceTypes.contains(pointerResourceRecord)) {
          serviceTypes.add(pointerResourceRecord);
        }
      }

      return serviceTypes;
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(
        context,
        AppLocalizations.of(context)!.error,
        error.toString(),
      );

      return null;
    } finally {}
  }

  Future<List<PtrResourceRecord>?> _findServices(
    MDnsClient client,
    String serviceType,
  ) async {
    try {
      final List<PtrResourceRecord> services = <PtrResourceRecord>[];

      await for (final PtrResourceRecord pointerResourceRecord
          in client.lookup<PtrResourceRecord>(
            ResourceRecordQuery.serverPointer(serviceType),
          )) {
        if (!services.contains(pointerResourceRecord)) {
          services.add(pointerResourceRecord);
        }
      }

      return services;
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(
        context,
        AppLocalizations.of(context)!.error,
        error.toString(),
      );

      return null;
    } finally {}
  }

  Future<List<IPAddressResourceRecord>?> _findIpAddessResourceRecords(
    MDnsClient client,
    String target,
  ) async {
    try {
      final List<IPAddressResourceRecord> ipAddressResourceRecords =
          <IPAddressResourceRecord>[];

      await for (final IPAddressResourceRecord iPAddressResourceRecord
          in client.lookup<IPAddressResourceRecord>(
            ResourceRecordQuery.addressIPv4(target),
          )) {
        if (!ipAddressResourceRecords.contains(iPAddressResourceRecord)) {
          ipAddressResourceRecords.add(iPAddressResourceRecord);
        }
      }

      await for (final IPAddressResourceRecord iPAddressResourceRecord
          in client.lookup<IPAddressResourceRecord>(
            ResourceRecordQuery.addressIPv6(target),
          )) {
        if (!ipAddressResourceRecords.contains(iPAddressResourceRecord)) {
          ipAddressResourceRecords.add(iPAddressResourceRecord);
        }
      }

      return ipAddressResourceRecords;
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(
        context,
        AppLocalizations.of(context)!.error,
        error.toString(),
      );

      return null;
    } finally {}
  }

  Future<SrvResourceRecord?> _findServiceResourceRecord(
    MDnsClient client,
    String serviceName,
  ) async {
    try {
      await for (final SrvResourceRecord serviceResourceRecord
          in client.lookup<SrvResourceRecord>(
            ResourceRecordQuery.service(serviceName),
          )) {
        return serviceResourceRecord;
      }

      return null;
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(
        context,
        AppLocalizations.of(context)!.error,
        error.toString(),
      );

      return null;
    } finally {}
  }

  Future<TxtResourceRecord?> _findTextResourceRecord(
    MDnsClient client,
    String serviceName,
  ) async {
    try {
      await for (final TxtResourceRecord textResourceRecord
          in client.lookup<TxtResourceRecord>(
            ResourceRecordQuery.text(serviceName),
          )) {
        return textResourceRecord;
      }

      return null;
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(
        context,
        AppLocalizations.of(context)!.error,
        error.toString(),
      );

      return null;
    } finally {}
  }

  Future<void> _scan() async {
    try {
      setState(() {
        _isScanning = true;
        _hosts.clear();
      });

      await _client.start();

      final List<PtrResourceRecord>? serviceTypes = await _findServiceTypes(
        _client,
      );

      for (final PtrResourceRecord serviceType in serviceTypes!) {
        if (_isScanning) {
          final List<PtrResourceRecord>? services = await _findServices(
            _client,
            serviceType.domainName,
          );

          for (final PtrResourceRecord service in services!) {
            if (_isScanning) {
              final SrvResourceRecord? serviceResourceRecord =
                  await _findServiceResourceRecord(_client, service.domainName);

              if (serviceResourceRecord == null) {
                continue;
              }

              final List<IPAddressResourceRecord>? ipAddressResourceRecords =
                  await _findIpAddessResourceRecords(
                    _client,
                    serviceResourceRecord.target,
                  );

              final TxtResourceRecord? textResourceRecord =
                  await _findTextResourceRecord(_client, service.domainName);

              setState(() {
                _hosts.add((
                  ipAddressResourceRecords: ipAddressResourceRecords!,
                  pointerResourceRecord: service,
                  serviceResourceRecord: serviceResourceRecord,
                  textResourceRecord: textResourceRecord,
                ));
              });
            } else {
              break;
            }
          }
        } else {
          break;
        }
      }

      setState(() {
        _hosts;
      });
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(
        navigatorKey.currentContext!,
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );
    } finally {
      _client.stop();

      setState(() {
        _isScanning = false;
      });
    }
  }

  void _stop(BuildContext context) {
    try {
      _client.stop();

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

  String? _extractServiceType(String value) {
    try {
      final List<String> parts = value.split('.');

      if (parts.length >= 3) {
        return '${parts[parts.length - 3]}.${parts[parts.length - 2]}';
      }

      return value;
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(
        context,
        AppLocalizations.of(context)!.error,
        error.toString(),
      );

      return null;
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

  Widget _buildInformationRow(
    BuildContext context,
    String title,
    String value,
  ) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "$title: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }

  Widget _buildInformationCard(
    ({
      List<IPAddressResourceRecord> ipAddressResourceRecords,
      PtrResourceRecord pointerResourceRecord,
      SrvResourceRecord serviceResourceRecord,
      TxtResourceRecord? textResourceRecord,
    })
    host,
  ) {
    final String dateTimeFormat = "MMMM dd, yyyy hh:mm:ss a";

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(host.pointerResourceRecord.domainName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildInformationRow(
              context,
              AppLocalizations.of(context)!.name_or_target,
              host.pointerResourceRecord.domainName,
            ),
            _buildInformationRow(
              context,
              AppLocalizations.of(context)!.domain_name_or_bundle_identifier,
              host.pointerResourceRecord.name,
            ),
            _buildInformationRow(
              context,
              AppLocalizations.of(context)!.service_target,
              host.serviceResourceRecord.target,
            ),
            _buildInformationRow(
              context,
              AppLocalizations.of(context)!.address,
              host.ipAddressResourceRecords
                  .map((IPAddressResourceRecord record) {
                    return record.address.address;
                  })
                  .join(', '),
            ),
            _buildInformationRow(
              context,
              AppLocalizations.of(context)!.port,
              '${host.serviceResourceRecord.port}',
            ),
            _buildInformationRow(
              context,
              AppLocalizations.of(context)!.service_type,
              _extractServiceType(host.pointerResourceRecord.domainName)!,
            ),
            const SizedBox(height: 8.0),
            Card(
              color: Theme.of(context).hoverColor,
              child: ListTile(
                title: Text(AppLocalizations.of(context)!.ptr_record),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildInformationRow(
                      context,
                      AppLocalizations.of(context)!.name,
                      host.pointerResourceRecord.name,
                    ),
                    _buildInformationRow(
                      context,
                      AppLocalizations.of(context)!.domain_name,
                      host.pointerResourceRecord.domainName,
                    ),
                    _buildInformationRow(
                      context,
                      AppLocalizations.of(context)!.record_type,
                      '${host.pointerResourceRecord.resourceRecordType}',
                    ),
                    _buildInformationRow(
                      context,
                      AppLocalizations.of(context)!.validity,
                      DateFormat(dateTimeFormat).format(
                        DateTime.fromMillisecondsSinceEpoch(
                          host.pointerResourceRecord.validUntil,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              color: Theme.of(context).hoverColor,
              child: ListTile(
                title: Text(AppLocalizations.of(context)!.srv_record),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildInformationRow(
                      context,
                      AppLocalizations.of(context)!.name,
                      host.serviceResourceRecord.name,
                    ),
                    _buildInformationRow(
                      context,
                      AppLocalizations.of(context)!.target,
                      host.serviceResourceRecord.target,
                    ),
                    _buildInformationRow(
                      context,
                      AppLocalizations.of(context)!.port,
                      '${host.serviceResourceRecord.port}',
                    ),
                    _buildInformationRow(
                      context,
                      AppLocalizations.of(context)!.priority,
                      '${host.serviceResourceRecord.priority}',
                    ),
                    _buildInformationRow(
                      context,
                      AppLocalizations.of(context)!.weight,
                      '${host.serviceResourceRecord.weight}',
                    ),
                    _buildInformationRow(
                      context,
                      AppLocalizations.of(context)!.record_type,
                      '${host.serviceResourceRecord.resourceRecordType}',
                    ),
                    _buildInformationRow(
                      context,
                      AppLocalizations.of(context)!.validity,
                      DateFormat(dateTimeFormat).format(
                        DateTime.fromMillisecondsSinceEpoch(
                          host.serviceResourceRecord.validUntil,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (host.textResourceRecord != null &&
                host.textResourceRecord!.text.isNotEmpty)
              Card(
                color: Theme.of(context).hoverColor,
                child: ListTile(
                  title: Text(AppLocalizations.of(context)!.txt_record),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildInformationRow(
                        context,
                        AppLocalizations.of(context)!.name,
                        host.textResourceRecord!.name,
                      ),
                      _buildInformationRow(
                        context,
                        AppLocalizations.of(context)!.record_type,
                        '${host.textResourceRecord!.resourceRecordType}',
                      ),
                      _buildInformationRow(
                        context,
                        AppLocalizations.of(context)!.validity,
                        DateFormat(dateTimeFormat).format(
                          DateTime.fromMillisecondsSinceEpoch(
                            host.textResourceRecord!.validUntil,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListTile(
                            title: Text(AppLocalizations.of(context)!.value),
                            subtitle: Text(host.textResourceRecord!.text),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _hosts.map((
        ({
          List<IPAddressResourceRecord> ipAddressResourceRecords,
          PtrResourceRecord pointerResourceRecord,
          SrvResourceRecord serviceResourceRecord,
          TxtResourceRecord? textResourceRecord,
        })
        host,
      ) {
        return _buildInformationCard(host);
      }).toList(),
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
            if (_isScanning) const Center(child: CircularProgressIndicator()),
            _resultWrapper(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _client.stop();

    super.dispose();
  }
}

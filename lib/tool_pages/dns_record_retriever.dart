/* By Abdullah As-Sadeed */

import 'dart:async';

import 'package:bitscoper_cyberkit/commons/application_toolbar.dart';
import 'package:bitscoper_cyberkit/commons/copy_to_clipboard.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/commons/notification_sender.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:dns_client/dns_client.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DNSRecordRetrieverPage extends StatefulWidget {
  const DNSRecordRetrieverPage({super.key});

  @override
  DNSRecordRetrieverPageState createState() {
    return DNSRecordRetrieverPageState();
  }
}

class DNSRecord {
  final String type, record;

  DNSRecord(this.type, this.record);
}

class DNSRecordRetrieverPageState extends State<DNSRecordRetrieverPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _hostEditingController = TextEditingController();
  final TextEditingController _providerEditingController =
      TextEditingController();
  final StreamController<String> _recordTypeController =
      StreamController<String>.broadcast();

  DnsOverHttps? _retriever;

  final NumberFormat _numberFormat = NumberFormat(
    '#',
    AppLocalizations.of(navigatorKey.currentContext!)!.localeName,
  );

  late final List<RRType> _selectedRecordTypes = RRType.values.toList();
  final String _dnsProviderExample = 'https://doh.dns.sb/dns-query';
  bool _isRetrieving = false;
  final List<DNSRecord> _records = [];

  void _selectRecordTypes(BuildContext context) async {
    try {
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder:
                (
                  BuildContext context,
                  void Function(void Function()) setDialogState,
                ) {
                  return AlertDialog(
                    title: Text(
                      "${_numberFormat.format(_selectedRecordTypes.length)} ${AppLocalizations.of(context)!.record_types}",
                    ),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: RRType.values.map((RRType type) {
                            final bool selected = _selectedRecordTypes.contains(
                              type,
                            );

                            return FilterChip(
                              label: Text(type.name.toUpperCase()),
                              selected: selected,
                              onSelected: (bool value) {
                                try {
                                  setDialogState(() {
                                    if (value) {
                                      _selectedRecordTypes.add(type);
                                    } else {
                                      _selectedRecordTypes.remove(type);
                                    }
                                  });
                                  setState(() {});
                                } catch (error) {
                                  debugPrint(error.toString());

                                  showMessageDialog(
                                    context,
                                    AppLocalizations.of(context)!.error,
                                    error.toString(),
                                  );
                                } finally {}
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          try {
                            Navigator.of(context).pop();
                          } catch (error) {
                            debugPrint(error.toString());

                            showMessageDialog(
                              context,
                              AppLocalizations.of(context)!.error,
                              error.toString(),
                            );
                          } finally {}
                        },
                        child: Text(AppLocalizations.of(context)!.ok),
                      ),
                    ],
                  );
                },
          );
        },
      );
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(
        navigatorKey.currentContext!,
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );
    } finally {}
  }

  String? _hostFieldValidator(BuildContext context, String? value) {
    if ((value == null) || value.isEmpty) {
      return AppLocalizations.of(context)!.enter_a_host_or_ip_address;
    } else {
      return null;
    }
  }

  String? _providerFieldValidator(BuildContext context, String? value) {
    if ((value == null) || value.isEmpty) {
      return AppLocalizations.of(context)!.enter_a_host_or_ip_address;
    } else {
      return null;
    }
  }

  Future<void> _retrieve(BuildContext context) async {
    try {
      if (_formKey.currentState!.validate()) {
        if (_selectedRecordTypes.isEmpty) {
          showMessageDialog(
            context,
            AppLocalizations.of(context)!.error,
            AppLocalizations.of(context)!.select_at_least_one_record_type,
          );

          return;
        }

        _retriever = DnsOverHttps(
          _providerEditingController.text.trim(),
          maximalPrivacy: true,
        );

        setState(() {
          _isRetrieving = true;
          _records.clear();
        });

        for (RRType recordType in _selectedRecordTypes) {
          if (_isRetrieving) {
            try {
              _recordTypeController.add(recordType.name.toUpperCase());

              final List<String>? response = await _retriever
                  ?.lookupDataByRRType(
                    _hostEditingController.text.trim(),
                    recordType,
                  );

              for (final String record in response!) {
                _records.add(DNSRecord(recordType.name.toUpperCase(), record));
              }
            } catch (error) {
              debugPrint(error.toString());

              showMessageDialog(
                navigatorKey.currentContext!,
                AppLocalizations.of(navigatorKey.currentContext!)!.error,
                error.toString(),
              );

              continue;
            } finally {}
          }
        }

        await sendNotification(
          title: AppLocalizations.of(navigatorKey.currentContext!)!
              .dns_record_retriever,
          subtitle: AppLocalizations.of(navigatorKey.currentContext!)!
              .bitscoper_cyberkit,
          body: AppLocalizations.of(navigatorKey.currentContext!)!.retrieved,
          payload: "DNS_Record_Retriever",
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
        _retriever?.close();

        _isRetrieving = false;
      });
    }
  }

  void _stop(BuildContext context) {
    try {
      setState(() {
        _isRetrieving = false;

        _retriever?.close();
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
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _hostEditingController,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.a_host_or_ip_address,
              hintText: 'bitscoper.dev',
            ),
            showCursor: true,
            maxLines: 1,
            validator: (String? value) {
              return _hostFieldValidator(context, value);
            },
            onChanged: (String value) {},
            onFieldSubmitted: (String value) {
              _retrieve(context);
            },
            autofocus: true,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _providerEditingController,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.dns_provider,
              hintText: _dnsProviderExample,
            ),
            showCursor: true,
            maxLines: 1,
            validator: (String? value) {
              return _providerFieldValidator(context, value);
            },
            onChanged: (String value) {},
            onFieldSubmitted: (String value) {
              _retrieve(context);
            },
            autofocus: false,
          ),
          const SizedBox(height: 16.0),
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.checklist_rounded),
              label: Text(
                "${_numberFormat.format(_selectedRecordTypes.length)} ${AppLocalizations.of(context)!.types}",
              ),
              onPressed: () {
                _selectRecordTypes(context);
              },
            ),
          ),
          const SizedBox(height: 16.0),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _isRetrieving
                      ? null
                      : () {
                          _retrieve(context);
                        },
                  child: Text(AppLocalizations.of(context)!.retrieve),
                ),
                ElevatedButton(
                  onPressed: _isRetrieving
                      ? () {
                          _stop(context);
                        }
                      : null,
                  child: Text(AppLocalizations.of(context)!.stop),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: StreamBuilder<String>(
            stream: _recordTypeController.stream,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text(AppLocalizations.of(context)!.wait);
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return Text(
                  '${AppLocalizations.of(context)!.retrieving} ${snapshot.data} ${AppLocalizations.of(context)!.records}',
                );
              } else if (snapshot.hasError) {
                showMessageDialog(
                  context,
                  AppLocalizations.of(context)!.error,
                  snapshot.toString(),
                );

                return const SizedBox.shrink();
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
        const SizedBox(height: 16.0),
        const Center(child: CircularProgressIndicator()),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _resultColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _records.map((record) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Card(
            child: ListTile(
              title: Text(record.type),
              subtitle: Text(record.record),
              trailing: IconButton(
                icon: const Icon(Icons.copy_rounded),
                onPressed: () {
                  copyToClipboard(
                    context,
                    '${record.type} ${AppLocalizations.of(context)!.dns_record}',
                    record.record,
                  );
                },
                tooltip: AppLocalizations.of(context)!.copy_to_clipboard,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(context)!.dns_record_retriever,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _form(context),
            const SizedBox(height: 16.0),
            if (_isRetrieving) _progressStatus(),
            _resultColumn(context),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _providerEditingController.text = _dnsProviderExample;
  }

  @override
  void dispose() {
    _hostEditingController.dispose();
    _providerEditingController.dispose();
    _recordTypeController.close();
    _retriever?.close();

    super.dispose();
  }
}

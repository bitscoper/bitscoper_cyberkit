/* By Abdullah As-Sadeed */

import 'dart:async';
import 'package:bitscoper_cyberkit/commons/application_toolbar.dart';
import 'package:bitscoper_cyberkit/commons/copy_to_clipboard.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/commons/notification_sender.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:dnsolve/dnsolve.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DNSRecordRetrieverPage extends StatefulWidget {
  const DNSRecordRetrieverPage({super.key});

  @override
  DNSRecordRetrieverPageState createState() => DNSRecordRetrieverPageState();
}

class DNSRecord {
  final String type, record;

  DNSRecord(this.type, this.record);
}

class DNSRecordRetrieverPageState extends State<DNSRecordRetrieverPage> {
  @override
  void initState() {
    super.initState();
  }

  final NumberFormat _numberFormat = NumberFormat(
    '#',
    AppLocalizations.of(navigatorKey.currentContext!)!.localeName,
  );

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _hostEditingController = TextEditingController();
  final TextEditingController _providerEditingController =
      TextEditingController();
  late StreamController<String> _recordTypeController;

  List<RecordType> _selectedRecordTypes = RecordType.values.toList();
  bool _isRetrieving = false;
  List<DNSRecord> _records = [];

  void _selectRecordTypes() async {
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
                      "${_numberFormat.format(_selectedRecordTypes.length)} ${AppLocalizations.of(navigatorKey.currentContext!)!.record_types}",
                    ),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: RecordType.values.map((RecordType type) {
                            final bool selected = _selectedRecordTypes.contains(
                              type,
                            );

                            return FilterChip(
                              label: Text(
                                type.toString().split('.').last.toUpperCase(),
                              ),
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
                                    AppLocalizations.of(
                                      navigatorKey.currentContext!,
                                    )!.error,
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
                            Navigator.of(navigatorKey.currentContext!).pop();
                          } catch (error) {
                            debugPrint(error.toString());

                            showMessageDialog(
                              AppLocalizations.of(
                                navigatorKey.currentContext!,
                              )!.error,
                              error.toString(),
                            );
                          } finally {}
                        },
                        child: Text(
                          AppLocalizations.of(navigatorKey.currentContext!)!.ok,
                        ),
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
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );
    } finally {}
  }

  String? _hostFieldValidator(String? value) {
    if ((value == null) || value.isEmpty) {
      return AppLocalizations.of(
        navigatorKey.currentContext!,
      )!.enter_a_host_or_ip_address;
    } else {
      return null;
    }
  }

  String? _providerFieldValidator(String? value) {
    if ((value == null) || value.isEmpty) {
      return AppLocalizations.of(
        navigatorKey.currentContext!,
      )!.enter_a_host_or_ip_address;
    } else {
      return null;
    }
  }

  Future<void> _retrieve() async {
    try {
      if (_formKey.currentState!.validate()) {
        if (_selectedRecordTypes.isEmpty) {
          showMessageDialog(
            AppLocalizations.of(navigatorKey.currentContext!)!.error,
            AppLocalizations.of(
              navigatorKey.currentContext!,
            )!.select_at_least_one_record_type,
          );

          return;
        }

        final DNSolve dnsolve = DNSolve();
        _recordTypeController = StreamController<String>.broadcast();

        setState(() {
          _isRetrieving = true;
          _records = [];
        });

        for (RecordType recordType in _selectedRecordTypes) {
          _recordTypeController.add(
            recordType.toString().replaceFirst('RecordType.', '').toUpperCase(),
          );

          final ResolveResponse response = await dnsolve.lookup(
            _hostEditingController.text.trim(),
            dnsSec: true,
            type: recordType,
            server: DNSServer.custom(_providerEditingController.text.trim()),
          );

          if (response.answer!.records != null) {
            for (final record in response.answer!.records!) {
              _records.add(
                DNSRecord(
                  recordType.toString().split('.').last.toUpperCase(),
                  record.toBind,
                ),
              );
            }
          }
        }

        await sendNotification(
          title: AppLocalizations.of(
            navigatorKey.currentContext!,
          )!.dns_record_retriever,
          subtitle: AppLocalizations.of(
            navigatorKey.currentContext!,
          )!.bitscoper_cyberkit,
          body: AppLocalizations.of(navigatorKey.currentContext!)!.retrieved,
          payload: "DNS_Record_Retriever",
        );

        dnsolve.dispose();
      }
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );
    } finally {
      setState(() {
        _recordTypeController.close();
        _recordTypeController = StreamController<String>();

        _isRetrieving = false;
      });
    }
  }

  void _stop() {
    try {
      setState(() {
        _isRetrieving = false;
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
            controller: _hostEditingController,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: AppLocalizations.of(
                navigatorKey.currentContext!,
              )!.a_host_or_ip_address,
              hintText: 'bitscoper.dev',
            ),
            showCursor: true,
            maxLines: 1,
            validator: _hostFieldValidator,
            onChanged: (String value) {},
            onFieldSubmitted: (String value) {
              _retrieve();
            },
          ),
          const SizedBox(height: 16.0),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: TextFormField(
                  controller: _providerEditingController,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: AppLocalizations.of(
                      navigatorKey.currentContext!,
                    )!.dns_provider,
                    hintText: '9.9.9.9',
                  ),
                  showCursor: true,
                  maxLines: 1,
                  validator: _providerFieldValidator,
                  onChanged: (String value) {},
                  onFieldSubmitted: (String value) {
                    _retrieve();
                  },
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                flex: 1,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.checklist_rounded),
                  label: Text(
                    "${_numberFormat.format(_selectedRecordTypes.length)} ${AppLocalizations.of(navigatorKey.currentContext!)!.types}",
                  ),
                  onPressed: _selectRecordTypes,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _isRetrieving ? null : _retrieve,
                  child: Text(
                    AppLocalizations.of(navigatorKey.currentContext!)!.retrieve,
                  ),
                ),
                ElevatedButton(
                  onPressed: _isRetrieving ? _stop : null,
                  child: Text(
                    AppLocalizations.of(navigatorKey.currentContext!)!.stop,
                  ),
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
                  AppLocalizations.of(context)!.error,
                  snapshot.toString(),
                );

                return const SizedBox();
              } else {
                return const SizedBox();
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

  Widget _resultColumn() {
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
                  try {
                    copyToClipboard(
                      '${record.type} ${AppLocalizations.of(navigatorKey.currentContext!)!.dns_record}',
                      record.record,
                    );
                  } catch (error) {
                    debugPrint(error.toString());

                    showMessageDialog(
                      AppLocalizations.of(navigatorKey.currentContext!)!.error,
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
            _form(),
            const SizedBox(height: 16.0),
            if (_isRetrieving) _progressStatus(),
            _resultColumn(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hostEditingController.dispose();
    _providerEditingController.dispose();
    _recordTypeController.close();

    super.dispose();
  }
}

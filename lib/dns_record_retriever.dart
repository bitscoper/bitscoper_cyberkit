/* By Abdullah As-Sadeed */

import 'dart:async';
import 'package:dnsolve/dnsolve.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:bitscoper_cyber_toolbox/copy_to_clipboard.dart';

class DNSRecordRetrieverPage extends StatelessWidget {
  const DNSRecordRetrieverPage({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.dns_record_retriever,
        ),
        centerTitle: true,
      ),
      body: const DNSRecordRetrieverBody(),
    );
  }
}

class DNSRecordRetrieverBody extends StatefulWidget {
  const DNSRecordRetrieverBody({super.key});

  @override
  DNSRecordRetrieverBodyState createState() => DNSRecordRetrieverBodyState();
}

class DNSRecord {
  final String type, record;

  DNSRecord(
    this.type,
    this.record,
  );
}

class DNSRecordRetrieverBodyState extends State<DNSRecordRetrieverBody> {
  final _formKey = GlobalKey<FormState>();
  late String host;

  DNSProvider recordProvider = DNSProvider.cloudflare;

  bool isRetrieving = false;
  StreamController<String> recordTypeController =
      StreamController<String>.broadcast();
  List<DNSRecord> records = [];

  Future<void> retrieveDNSRecord() async {
    setState(
      () {
        isRetrieving = true;
        records = [];
      },
    );

    for (var recordType in RecordType.values) {
      if (!isRetrieving) {
        break;
      }

      recordTypeController.add(
          recordType.toString().replaceFirst('RecordType.', '').toUpperCase());

      final response = await DNSolve().lookup(
        host,
        dnsSec: true,
        type: recordType,
        provider: recordProvider,
      );

      if (response.answer!.records != null) {
        for (final record in response.answer!.records!) {
          records.add(
            DNSRecord(
              recordType.toString().split('.').last.toUpperCase(),
              record.toBind,
            ),
          );
        }
      }
    }

    if (!isRetrieving) {
      recordTypeController.close();
      recordTypeController = StreamController<String>();
    }

    setState(
      () {
        isRetrieving = false;
      },
    );
  }

  String capitalize(String string) {
    return string[0].toUpperCase() + string.substring(1);
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText:
                        AppLocalizations.of(context)!.a_host_or_ip_address,
                    hintText: 'bitscoper.dev',
                  ),
                  showCursor: true,
                  maxLines: 1,
                  validator: (
                    String? value,
                  ) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!
                          .enter_a_host_or_ip_address;
                    }

                    return null;
                  },
                  onChanged: (
                    String value,
                  ) {
                    host = value.trim();
                  },
                  onFieldSubmitted: (
                    String value,
                  ) {
                    if (_formKey.currentState!.validate()) {
                      retrieveDNSRecord();
                    }
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                DropdownButtonFormField<DNSProvider>(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.dns_provider,
                  ),
                  value: recordProvider,
                  onChanged: (
                    DNSProvider? newValue,
                  ) {
                    setState(
                      () {
                        recordProvider = newValue!;
                      },
                    );
                  },
                  items: DNSProvider.values.map<DropdownMenuItem<DNSProvider>>(
                    (
                      DNSProvider value,
                    ) {
                      return DropdownMenuItem<DNSProvider>(
                        value: value,
                        child: Text(
                          capitalize(
                            value.toString().split('.').last,
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
                const SizedBox(
                  height: 16,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: isRetrieving
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  retrieveDNSRecord();
                                }
                              },
                        child: Text(
                          AppLocalizations.of(context)!.retrieve,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: isRetrieving
                            ? () {
                                setState(
                                  () {
                                    isRetrieving = false;
                                  },
                                );
                              }
                            : null,
                        child: Text(
                          AppLocalizations.of(context)!.stop,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          if (isRetrieving)
            Center(
              child: Column(
                children: <Widget>[
                  StreamBuilder<String>(
                    stream: recordTypeController.stream,
                    builder: (
                      context,
                      snapshot,
                    ) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return Text(
                            '${AppLocalizations.of(context)!.retrieving} ${snapshot.data} ${AppLocalizations.of(context)!.records}');
                      } else {
                        return Text(AppLocalizations.of(context)!.wait);
                      }
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const CircularProgressIndicator(),
                ],
              ),
            )
          else
            records.isEmpty
                ? Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .it_takes_time_to_retrieve_all_possible_types_of_forward_and_reverse_records,
                      textAlign: TextAlign.center,
                    ),
                  )
                : Column(
                    children: records.map(
                      (record) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 8,
                          ),
                          child: Card(
                            child: ListTile(
                              title: Text(record.type),
                              subtitle: Text(record.record),
                              trailing: IconButton(
                                icon: const Icon(Icons.copy_rounded),
                                onPressed: () {
                                  copyToClipBoard(
                                    context,
                                    '${record.type} ${AppLocalizations.of(context)!.dns_record}',
                                    record.record,
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  )
        ],
      ),
    );
  }
}

// TODO: Add Bulk Save Button

/* By Abdullah As-Sadeed */

import 'dart:async';
import 'package:dnsolve/dnsolve.dart';
import 'package:flutter/material.dart';

import 'package:bitscoper_cyber_toolbox/copy_to_clipboard.dart';

class DNSRecordRetrieverPage extends StatelessWidget {
  const DNSRecordRetrieverPage({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DNS Record Retriever'),
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
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'A Host or IP Address',
                    hintText: 'bitscoper.dev',
                  ),
                  maxLines: 1,
                  showCursor: true,
                  onChanged: (value) {
                    host = value.trim();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a host or IP address!';
                    }
                    return null;
                  },
                  onFieldSubmitted: (value) {
                    if (_formKey.currentState!.validate()) {
                      retrieveDNSRecord();
                    }
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                DropdownButtonFormField<DNSProvider>(
                  decoration: const InputDecoration(
                    labelText: 'Select DNS Provider',
                  ),
                  value: recordProvider,
                  onChanged: (DNSProvider? newValue) {
                    setState(
                      () {
                        recordProvider = newValue!;
                      },
                    );
                  },
                  items: DNSProvider.values.map<DropdownMenuItem<DNSProvider>>(
                    (DNSProvider value) {
                      return DropdownMenuItem<DNSProvider>(
                        value: value,
                        child: Text(
                          capitalize(value.toString().split('.').last),
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
                    children: [
                      ElevatedButton(
                        onPressed: isRetrieving
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  retrieveDNSRecord();
                                }
                              },
                        child: const Text('Lookup'),
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
                        child: const Text('Stop'),
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
          isRetrieving
              ? Center(
                  child: Column(
                    children: [
                      StreamBuilder<String>(
                        stream: recordTypeController.stream,
                        builder: (
                          context,
                          snapshot,
                        ) {
                          if (snapshot.hasData && snapshot.data != null) {
                            return Text('Retrieving ${snapshot.data} records');
                          } else {
                            return const Text('Please Wait');
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
              : (records.isEmpty
                  ? const Center(
                      child: Text(
                        'It takes time to retrieve all possible types of forward and reverse records.',
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
                                      '${record.type} DNS record',
                                      record.record,
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ))
        ],
      ),
    );
  }
}

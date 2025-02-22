/* By Abdullah As-Sadeed */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:tcp_scanner/tcp_scanner.dart';

class TCPPortScannerPage extends StatelessWidget {
  const TCPPortScannerPage({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.tcp_port_scanner,
        ),
        centerTitle: true,
      ),
      body: const TCPPortScannerBody(),
    );
  }
}

class TCPPortScannerBody extends StatefulWidget {
  const TCPPortScannerBody({super.key});

  @override
  TCPPortScannerBodyState createState() => TCPPortScannerBodyState();
}

class TCPPortScannerBodyState extends State<TCPPortScannerBody> {
  final _formKey = GlobalKey<FormState>();
  late String host;

  final List<int> portList = List.generate(65536, (i) => i);
  final Stopwatch stopwatch = Stopwatch();

  bool isScanning = false;
  double scanProgress = 0.0;
  late List<int> openPorts;
  String scanInformation = '';

  Future<void> scanTCPPorts() async {
    setState(
      () {
        isScanning = true;
      },
    );
    stopwatch.start();

    try {
      await TcpScannerTask(
        host,
        portList,
        shuffle: true,
        parallelism: 64,
      )
          .start()
          .asStream()
          .transform(
            StreamTransformer.fromHandlers(
              handleData: (
                report,
                sink,
              ) {
                scanProgress = 1.0;

                openPorts = report.openPorts;
                openPorts = openPorts.cast<int>();
                openPorts.sort();

                setState(
                  () {
                    final numberFormat = NumberFormat(
                        '#', AppLocalizations.of(context)!.localeName);
                    final timeFormat = DateFormat(
                        'HH:mm:ss', AppLocalizations.of(context)!.localeName);

                    scanInformation =
                        '${AppLocalizations.of(context)!.scanned_ports}: ${numberFormat.format(report.ports.length)}\n${AppLocalizations.of(context)!.elapsed_time}: ${timeFormat.format(DateTime.fromMillisecondsSinceEpoch(
                      stopwatch.elapsedMilliseconds,
                      isUtc: true,
                    ))}';
                  },
                );

                sink.add(report);
              },
              handleError: (
                error,
                stackTrace,
                sink,
              ) {
                setState(
                  () {
                    scanInformation =
                        '${AppLocalizations.of(context)!.error}: $error';
                  },
                );

                sink.addError(
                  error,
                  stackTrace,
                );
              },
              handleDone: (sink) {
                sink.close();

                isScanning = false;
              },
            ),
          )
          .toList();
    } catch (error) {
      setState(
        () {
          scanInformation = '${AppLocalizations.of(context)!.error}: $error';
        },
      );

      isScanning = false;
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final numberFormat =
        NumberFormat('#', AppLocalizations.of(context)!.localeName);

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
                  onFieldSubmitted: (value) async {
                    if (_formKey.currentState!.validate()) {
                      stopwatch.reset();

                      setState(
                        () {
                          scanProgress = 0.0;
                        },
                      );

                      await scanTCPPorts();
                    }
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Center(
                  child: isScanning
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              stopwatch.reset();

                              setState(
                                () {
                                  scanProgress = 0.0;
                                },
                              );

                              await scanTCPPorts();
                            }
                          },
                          child: Text(
                            AppLocalizations.of(context)!.scan,
                          ),
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          if (scanProgress == 1.0) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                for (var port in openPorts)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: Text(
                      numberFormat.format(port),
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(
            height: 16,
          ),
          Text(scanInformation),
        ],
      ),
    );
  }
}

// TODO: Add Save Button

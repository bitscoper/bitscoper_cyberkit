/* By Abdullah As-Sadeed */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tcp_scanner/tcp_scanner.dart';

class TCPPortScannerPage extends StatelessWidget {
  const TCPPortScannerPage({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.tcp_port_scanner),
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
                    scanInformation = 'Scanned ports:\t${report.ports.length}\n'
                        'Elapsed:\t${stopwatch.elapsed}';
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
                    scanInformation = 'Error: $error';
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
          scanInformation = 'Error: $error';
        },
      );

      isScanning = false;
    }
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
                          child: const Text('Scan'),
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
                      port.toString(),
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

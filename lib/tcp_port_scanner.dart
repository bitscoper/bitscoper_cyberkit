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
        elevation: 4.0,
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

  final Stopwatch _stopwatch = Stopwatch();

  final List<int> _portList = List.generate(
    65536,
    (iteration) => iteration,
  );

  late String _host;
  bool _isScanning = false;
  double _scanProgress = 0.0;
  late List<int> _openPorts;
  String _scanInformation = '';

  Future<void> scanTCPPorts() async {
    setState(
      () {
        _isScanning = true;
      },
    );
    _stopwatch.start();

    try {
      await TcpScannerTask(
        _host,
        _portList,
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
                _scanProgress = 1.0;

                _openPorts = report.openPorts;
                _openPorts = _openPorts.cast<int>();
                _openPorts.sort();

                setState(
                  () {
                    final numberFormat = NumberFormat(
                        '#', AppLocalizations.of(context)!.localeName);
                    final timeFormat = DateFormat(
                        'HH:mm:ss', AppLocalizations.of(context)!.localeName);

                    _scanInformation =
                        '${AppLocalizations.of(context)!.scanned_ports}: ${numberFormat.format(report.ports.length)}\n${AppLocalizations.of(context)!.elapsed_time}: ${timeFormat.format(DateTime.fromMillisecondsSinceEpoch(
                      _stopwatch.elapsedMilliseconds,
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
                    _scanInformation =
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

                _isScanning = false;
              },
            ),
          )
          .toList();
    } catch (error) {
      setState(
        () {
          _scanInformation = '${AppLocalizations.of(context)!.error}: $error';
        },
      );

      _isScanning = false;
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final numberFormat =
        NumberFormat('#', AppLocalizations.of(context)!.localeName);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
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
                    _host = value.trim();
                  },
                  onFieldSubmitted: (value) async {
                    if (_formKey.currentState!.validate()) {
                      _stopwatch.reset();

                      setState(
                        () {
                          _scanProgress = 0.0;
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
                  child: _isScanning
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _stopwatch.reset();

                              setState(
                                () {
                                  _scanProgress = 0.0;
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
          if (_scanProgress == 1.0) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                for (int port in _openPorts)
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
          Text(_scanInformation),
        ],
      ),
    );
  }
}

// TODO: Add Save Button

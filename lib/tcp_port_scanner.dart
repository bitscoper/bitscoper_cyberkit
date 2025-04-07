/* By Abdullah As-Sadeed */

import 'dart:async';
import 'package:bitscoper_cyber_toolbox/application_toolbar.dart';
import 'package:bitscoper_cyber_toolbox/l10n/app_localizations.dart';
import 'package:bitscoper_cyber_toolbox/main.dart';
import 'package:bitscoper_cyber_toolbox/message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcp_scanner/tcp_scanner.dart';

class TCPPortScannerPage extends StatelessWidget {
  const TCPPortScannerPage({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(context)!.tcp_port_scanner,
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
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _hostEditingController = TextEditingController();

  final Stopwatch _stopwatch = Stopwatch();

  final List<int> _portList = List.generate(
    65536,
    (
      int iteration,
    ) =>
        iteration,
  );

  bool _isScanning = false;
  List<int> _openPorts = [];
  String _scanInformation = '';

  Future<void> _scanTCPPorts() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(
          () {
            _isScanning = true;
          },
        );

        _stopwatch.reset();
        _stopwatch.start();

        await TcpScannerTask(
          _hostEditingController.text.trim(),
          _portList,
          shuffle: false,
          parallelism: 64,
        )
            .start()
            .asStream()
            .transform(
              StreamTransformer.fromHandlers(
                handleData: (
                  TcpScannerTaskReport report,
                  EventSink<Object?> sink,
                ) {
                  setState(
                    () {
                      _openPorts = report.openPorts.cast<int>();
                      _openPorts.sort();

                      final NumberFormat numberFormat = NumberFormat(
                        '#',
                        AppLocalizations.of(context)!.localeName,
                      );
                      final DateFormat timeFormat = DateFormat(
                        'HH:mm:ss',
                        AppLocalizations.of(context)!.localeName,
                      );

                      _scanInformation =
                          '${AppLocalizations.of(context)!.scanned_ports}: ${numberFormat.format(report.ports.length)}\n${AppLocalizations.of(context)!.elapsed_time}: ${timeFormat.format(
                        DateTime.fromMillisecondsSinceEpoch(
                          _stopwatch.elapsedMilliseconds,
                          isUtc: true,
                        ),
                      )}';
                    },
                  );

                  sink.add(report);
                },
                handleDone: (
                  EventSink<Object?> sink,
                ) {
                  sink.close();
                },
                handleError: (
                  error,
                  stackTrace,
                  sink,
                ) {
                  showMessageDialog(
                    AppLocalizations.of(navigatorKey.currentContext!)!.error,
                    error.toString(),
                  );

                  sink.addError(
                    error,
                    stackTrace,
                  );

                  sink.close();
                },
              ),
            )
            .toList();
      } catch (error) {
        showMessageDialog(
          AppLocalizations.of(navigatorKey.currentContext!)!.error,
          error.toString(),
        );
      } finally {
        setState(
          () {
            _isScanning = false;
          },
        );
      }
    }
  }

  @override
  void dispose() {
    _hostEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final NumberFormat numberFormat =
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
                  controller: _hostEditingController,
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
                  ) {},
                  onFieldSubmitted: (
                    String value,
                  ) async {
                    await _scanTCPPorts();
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
                            await _scanTCPPorts();
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
          if (!_isScanning)
            Column(
              children: <Widget>[
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
                const SizedBox(
                  height: 16,
                ),
                Text(_scanInformation),
              ],
            ),
        ],
      ),
    );
  }
}

// TODO: Add Save Button

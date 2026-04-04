/* By Abdullah As-Sadeed */

import 'dart:async';
import 'package:bitscoper_cyberkit/commons/application_toolbar.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/commons/notification_sender.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tcp_scanner/tcp_scanner.dart';

class TCPPortScannerPage extends StatefulWidget {
  const TCPPortScannerPage({super.key});

  @override
  TCPPortScannerPageState createState() {
    return TCPPortScannerPageState();
  }
}

class TCPPortScannerPageState extends State<TCPPortScannerPage> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _hostEditingController = TextEditingController();
  final TextEditingController _parallelismEditingController =
      TextEditingController(text: '64');

  final Stopwatch _stopwatch = Stopwatch();

  final List<int> _portList = List.generate(65536, (int iteration) {
    return iteration;
  });

  bool _isScanning = false;
  List<int> _openPorts = [];
  String _scanInformation = '';

  String? _hostFieldValidator(BuildContext context, String? value) {
    if ((value == null) || value.isEmpty) {
      return AppLocalizations.of(context)!.enter_a_host_or_ip_address;
    } else {
      return null;
    }
  }

  Future<void> _scan(BuildContext context) async {
    try {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isScanning = true;
        });

        _stopwatch.reset();
        _stopwatch.start();

        await TcpScannerTask(
              _hostEditingController.text.trim(),
              _portList,
              shuffle: false,
              parallelism: int.parse(_parallelismEditingController.text.trim()),
            )
            .start()
            .asStream()
            .transform(
              StreamTransformer.fromHandlers(
                handleData: (TcpScannerTaskReport report, EventSink<Object?> sink) {
                  setState(() {
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
                        '${AppLocalizations.of(context)!.scanned_ports}: ${numberFormat.format(report.ports.length)}\n${AppLocalizations.of(context)!.elapsed_time}: ${timeFormat.format(DateTime.fromMillisecondsSinceEpoch(_stopwatch.elapsedMilliseconds, isUtc: true))}';
                  });

                  sink.add(report);
                },
                handleDone: (EventSink<Object?> sink) async {
                  sink.close();

                  await sendNotification(
                    title: AppLocalizations.of(context)!.tcp_port_scanner,
                    subtitle: AppLocalizations.of(context)!.bitscoper_cyberkit,
                    body: AppLocalizations.of(context)!.scanned,
                    payload: "TCP_Port_Scanner",
                  );
                },
                handleError:
                    (
                      Object error,
                      StackTrace stackTrace,
                      EventSink<Object?> sink,
                    ) {
                      showMessageDialog(
                        context,
                        AppLocalizations.of(context)!.error,
                        error.toString(),
                      );

                      sink.addError(error, stackTrace);

                      sink.close();
                    },
              ),
            )
            .toList();
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
        _isScanning = false;
      });
    }
  }

  Widget _form(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextFormField(
                    controller: _hostEditingController,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: AppLocalizations.of(
                        context,
                      )!.a_host_or_ip_address,
                      hintText: 'bitscoper.dev',
                    ),
                    showCursor: true,
                    maxLines: 1,
                    validator: (String? value) {
                      return _hostFieldValidator(context, value);
                    },
                    onChanged: (String value) {},
                    onFieldSubmitted: (String value) {
                      _scan(context);
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextFormField(
                    controller: _parallelismEditingController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)!.parallelism,
                      hintText: '64',
                    ),
                    showCursor: true,
                    maxLines: 1,
                    onChanged: (String value) {},
                    onFieldSubmitted: (String value) {
                      _scan(context);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Center(
            child: _isScanning
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      _scan(context);
                    },
                    child: Text(AppLocalizations.of(context)!.scan),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _resultColumn(BuildContext context) {
    final NumberFormat numberFormat = NumberFormat(
      '#',
      AppLocalizations.of(context)!.localeName,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: <Widget>[
            for (int port in _openPorts)
              Chip(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.only(
                  top: 8.0,
                  right: 4.0,
                  bottom: 8.0,
                  left: 4.0,
                ),
                label: Text(numberFormat.format(port)),
              ),
          ],
        ),
        const SizedBox(height: 16.0),
        Text(_scanInformation),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(context)!.tcp_port_scanner,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _form(context),
            const SizedBox(height: 16.0),
            if (!_isScanning) _resultColumn(context),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hostEditingController.dispose();
    _parallelismEditingController.dispose();

    super.dispose();
  }
}

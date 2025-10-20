/* By Abdullah As-Sadeed */

import 'dart:convert';
import 'package:bitscoper_cyberkit/commons/application_toolbar.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/material.dart';
import 'package:timelines_plus/timelines_plus.dart';

class PingerPage extends StatefulWidget {
  const PingerPage({super.key});

  @override
  PingerPageState createState() => PingerPageState();
}

class PingResult {
  final String ipAddress, ttl, time;

  PingResult(this.ipAddress, this.ttl, this.time);
}

class PingerPageState extends State<PingerPage> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _hostEditingController = TextEditingController();

  bool _isPinging = false;
  List<PingResult> _results = [];

  Future<void> _ping() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _isPinging = true;
          _results = [];
        });

        while (_isPinging) {
          final String response = (
            await Ping(
              _hostEditingController.text.trim(),
              encoding: const Utf8Codec(),
              count: 1,
            ).stream.first,
          ).toString();

          final RegExp expression = RegExp(
            r'ip:(.*?), ttl:(.*?), time:(.*?) ms',
          );

          final RegExpMatch? match = expression.firstMatch(response);

          if (match != null) {
            setState(() {
              _results.insert(
                0,
                PingResult(
                  match.group(1)?.trim() ?? '',
                  match.group(2)?.trim() ?? '',
                  match.group(3)?.trim() ?? '',
                ),
              );
            });
          }
        }
      } catch (error) {
        showMessageDialog(
          AppLocalizations.of(navigatorKey.currentContext!)!.error,
          error.toString(),
        );
      } finally {
        setState(() {
          _isPinging = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _hostEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(navigatorKey.currentContext!)!.pinger,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
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
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(
                          navigatorKey.currentContext!,
                        )!.enter_a_host_or_ip_address;
                      }
                      return null;
                    },
                    onChanged: (String value) {},
                    onFieldSubmitted: (String value) {
                      _ping();
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: _isPinging
                            ? null
                            : () async {
                                await _ping();
                              },
                        child: Text(
                          AppLocalizations.of(
                            navigatorKey.currentContext!,
                          )!.ping,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _isPinging
                            ? () {
                                setState(() {
                                  _isPinging = false;
                                });
                              }
                            : null,
                        child: Text(
                          AppLocalizations.of(
                            navigatorKey.currentContext!,
                          )!.stop,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            if (_isPinging)
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(child: CircularProgressIndicator()),
                  SizedBox(height: 16.0),
                ],
              ),
            if (_results.isNotEmpty)
              Expanded(
                child: Timeline.tileBuilder(
                  builder: TimelineTileBuilder.connected(
                    itemCount: _results.length,
                    nodePositionBuilder: (BuildContext context, int index) => 0,
                    connectionDirection: ConnectionDirection.before,
                    indicatorBuilder: (BuildContext context, int index) =>
                        OutlinedDotIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    connectorBuilder:
                        (BuildContext context, int index, ConnectorType type) =>
                            SolidLineConnector(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                    contentsBuilder: (BuildContext context, int index) {
                      final PingResult result = _results[index];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: ListTile(
                            leading: const Icon(Icons.network_ping_rounded),
                            title: Text(result.ipAddress),
                            subtitle: Text(
                              '${AppLocalizations.of(navigatorKey.currentContext!)!.ttl}: ${result.ttl}    ${AppLocalizations.of(navigatorKey.currentContext!)!.time}: ${result.time} ms',
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

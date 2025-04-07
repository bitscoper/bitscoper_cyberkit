/* By Abdullah As-Sadeed */

import 'dart:convert';
import 'package:bitscoper_cyber_toolbox/application_toolbar.dart';
import 'package:bitscoper_cyber_toolbox/l10n/app_localizations.dart';
import 'package:bitscoper_cyber_toolbox/main.dart';
import 'package:bitscoper_cyber_toolbox/message_dialog.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/material.dart';

class PingerPage extends StatelessWidget {
  const PingerPage({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(context)!.pinger,
      ),
      body: const PingerBody(),
    );
  }
}

class PingerBody extends StatefulWidget {
  const PingerBody({super.key});

  @override
  PingerBodyState createState() => PingerBodyState();
}

class PingerBodyState extends State<PingerBody> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _hostEditingController = TextEditingController();

  bool _isPinging = false;
  String _response = '', _result = '';

  Future<void> ping() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(
          () {
            _isPinging = true;
            _result = '';
          },
        );

        while (_isPinging) {
          _response = (
            await Ping(
              _hostEditingController.text.trim(),
              // ipv6: false,
              encoding: const Utf8Codec(),
              count: 1,
            ).stream.first,
          ).toString();

          final RegExp expression =
              RegExp(r'ip:(.*?), ttl:(.*?), time:(.*?) ms');

          final RegExpMatch? match = expression.firstMatch(_response);

          if (match != null) {
            setState(
              () {
                _result =
                    '${match.group(1)?.trim() ?? ''} TTL: ${match.group(2)?.trim() ?? ''} Time: ${match.group(3)?.trim() ?? ''} ms\n$_result';
              },
            );
          }
        }
      } catch (error) {
        showMessageDialog(
          AppLocalizations.of(navigatorKey.currentContext!)!.error,
          error.toString(),
        );
      } finally {
        setState(
          () {
            _isPinging = false;
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
                    await ping();
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: _isPinging
                          ? null
                          : () async {
                              await ping();
                            },
                      child: Text(
                        AppLocalizations.of(context)!.ping,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _isPinging
                          ? () {
                              setState(
                                () {
                                  _isPinging = false;
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
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Center(
            child: Column(
              children: <Widget>[
                if (_isPinging) ...[
                  const CircularProgressIndicator(),
                  const SizedBox(
                    height: 16,
                  ),
                ],
                Text(
                  _result,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

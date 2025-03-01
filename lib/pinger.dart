/* By Abdullah As-Sadeed */

import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PingerPage extends StatelessWidget {
  const PingerPage({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.pinger,
        ),
        centerTitle: true,
        elevation: 4.0,
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
  final _formKey = GlobalKey<FormState>();

  late String host;
  bool _isPinging = false;
  String _response = '', _ipAddress = '', _ttl = '', _time = '', _result = '';

  Future<void> ping() async {
    if (_formKey.currentState!.validate()) {
      setState(
        () {
          _isPinging = true;
        },
      );

      while (_isPinging) {
        _response = (
          await Ping(
            host,
            count: 1,
          ).stream.first,
        ).toString();

        final RegExp expression = RegExp(r'ip:(.*?), ttl:(.*?), time:(.*?) ms');

        final RegExpMatch? match = expression.firstMatch(_response);

        if (match != null) {
          _ipAddress = match.group(1)?.trim() ?? '';

          _ttl = match.group(2)?.trim() ?? '';

          _time = match.group(3)?.trim() ?? '';
        }

        setState(
          () {
            _result = '$_ipAddress TTL: $_ttl Time: $_time ms\n$_result';
          },
        );
      }
    }
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
                              if (_formKey.currentState!.validate()) {
                                setState(
                                  () {
                                    _isPinging = true;
                                  },
                                );

                                await ping();
                              }
                            },
                      child: Text(
                        AppLocalizations.of(context)!.ping,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _isPinging
                          ? () async {
                              if (_formKey.currentState!.validate()) {
                                setState(
                                  () {
                                    _isPinging = false;
                                    _result = '';
                                  },
                                );
                              }
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

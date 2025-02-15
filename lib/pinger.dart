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

  bool isPinging = false;
  String response = '', ipAddress = '', ttl = '', time = '', result = '';

  Future<void> ping() async {
    if (_formKey.currentState!.validate()) {
      setState(
        () {
          isPinging = true;
        },
      );

      while (isPinging) {
        response = (
          await Ping(
            host,
            count: 1,
          ).stream.first,
        ).toString();

        RegExp expression = RegExp(r'ip:(.*?), ttl:(.*?), time:(.*?) ms');

        RegExpMatch? match = expression.firstMatch(response);

        if (match != null) {
          ipAddress = match.group(1)?.trim() ?? '';
          ttl = match.group(2)?.trim() ?? '';
          time = match.group(3)?.trim() ?? '';
        }

        setState(
          () {
            result = '$ipAddress TTL: $ttl Time: $time ms\n$result';
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!
                          .enter_a_host_or_ip_address;
                    }

                    return null;
                  },
                  onChanged: (value) {
                    host = value.trim();
                  },
                  onFieldSubmitted: (value) async {
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
                      onPressed: isPinging
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(
                                  () {
                                    isPinging = true;
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
                      onPressed: isPinging
                          ? () async {
                              if (_formKey.currentState!.validate()) {
                                setState(
                                  () {
                                    isPinging = false;
                                    result = '';
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
                if (isPinging) ...[
                  const CircularProgressIndicator(),
                  const SizedBox(
                    height: 16,
                  ),
                ],
                Text(
                  result,
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

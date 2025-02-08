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
        title: Text(AppLocalizations.of(context)!.pinger),
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
                      return 'Please enter a host or IP Address!';
                    }

                    return null;
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
                  children: [
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
                      child: const Text('Ping'),
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
                      child: const Text('Stop'),
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
              children: [
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

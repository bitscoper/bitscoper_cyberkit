/* By Abdullah As-Sadeed */

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:bitscoper_cyber_toolbox/copy_to_clipboard.dart';

class StringHashCalculatorPage extends StatelessWidget {
  const StringHashCalculatorPage({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.string_hash_calculator,
        ),
        centerTitle: true,
        elevation: 4.0,
      ),
      body: const StringHashCalculatorBody(),
    );
  }
}

class StringHashCalculatorBody extends StatefulWidget {
  const StringHashCalculatorBody({super.key});

  @override
  StringHashCalculatorBodyState createState() =>
      StringHashCalculatorBodyState();
}

class StringHashCalculatorBodyState extends State<StringHashCalculatorBody> {
  final _formKey = GlobalKey<FormState>();

  String _string = '';
  Map<String, String> _hashValues = {};

  void _calculateHashes() {
    final bytes = utf8.encode(_string);

    final String md5Hash = md5.convert(bytes).toString();
    final String sha1Hash = sha1.convert(bytes).toString();
    final String sha224Hash = sha224.convert(bytes).toString();
    final String sha256Hash = sha256.convert(bytes).toString();
    final String sha384Hash = sha384.convert(bytes).toString();
    final String sha512Hash = sha512.convert(bytes).toString();

    setState(
      () {
        _hashValues = {
          'MD5': md5Hash,
          'SHA1': sha1Hash,
          'SHA224': sha224Hash,
          'SHA256': sha256Hash,
          'SHA384': sha384Hash,
          'SHA512': sha512Hash,
        };
      },
    );
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
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: AppLocalizations.of(context)!.a_multiline_string,
                hintText: AppLocalizations.of(context)!.abdullah_as_sadeed,
              ),
              showCursor: true,
              maxLines: null,
              validator: (
                String? value,
              ) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.enter_a_string;
                }

                return null;
              },
              onChanged: (
                String value,
              ) {
                setState(
                  () {
                    _string = value;

                    _calculateHashes();
                  },
                );
              },
              onFieldSubmitted: (
                String value,
              ) {
                if (_formKey.currentState!.validate()) {
                  setState(
                    () {
                      _string = value;

                      _calculateHashes();
                    },
                  );
                }
              },
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          if (_string.isEmpty)
            Center(
              child: Text(
                AppLocalizations.of(context)!
                    .start_typing_a_string_to_calculate_its_md5_sha1_sha224_sha256_sha384_sha512_hashes,
                textAlign: TextAlign.center,
              ),
            )
          else
            Column(
              children: <Widget>[
                for (MapEntry<String, dynamic> entry in _hashValues.entries)
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16,
                    ),
                    child: Card(
                      child: ListTile(
                        title: Text(entry.key),
                        subtitle: Text(entry.value),
                        trailing: IconButton(
                          icon: const Icon(Icons.copy_rounded),
                          onPressed: () {
                            copyToClipBoard(
                              context,
                              "${entry.key} ${AppLocalizations.of(context)!.hash}",
                              entry.value,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

// TODO: Add Bulk Save Button

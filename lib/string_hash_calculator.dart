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
  Map<String, String> hashValues = {};

  void calculateHashes(String input) {
    var bytes = utf8.encode(input);

    var md5Hash = md5.convert(bytes).toString();
    var sha1Hash = sha1.convert(bytes).toString();
    var sha224Hash = sha224.convert(bytes).toString();
    var sha256Hash = sha256.convert(bytes).toString();
    var sha384Hash = sha384.convert(bytes).toString();
    var sha512Hash = sha512.convert(bytes).toString();

    setState(
      () {
        hashValues = {
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
      padding: const EdgeInsets.all(16),
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.enter_a_string;
                }

                return null;
              },
              onChanged: (value) {
                setState(
                  () {
                    calculateHashes(value);
                  },
                );
              },
              onFieldSubmitted: (value) {
                if (_formKey.currentState!.validate()) {
                  setState(
                    () {
                      calculateHashes(value);
                    },
                  );
                }
              },
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          if (hashValues.isEmpty)
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
                for (var entry in hashValues.entries)
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

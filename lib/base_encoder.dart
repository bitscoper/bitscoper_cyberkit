/* By Abdullah As-Sadeed */

import "dart:convert";
import 'package:b/b.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:bitscoper_cyber_toolbox/copy_to_clipboard.dart';

class BaseEncoderPage extends StatelessWidget {
  const BaseEncoderPage({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.base_encoder),
        centerTitle: true,
      ),
      body: const BaseEncoderBody(),
    );
  }
}

class BaseEncoderBody extends StatefulWidget {
  const BaseEncoderBody({super.key});

  @override
  BaseEncoderBodyState createState() => BaseEncoderBodyState();
}

class BaseEncoderBodyState extends State<BaseEncoderBody> {
  final _formKey = GlobalKey<FormState>();
  late String inputAsBase64 = '';

  final encodings = {
    'Binary (Base2)': base2,
    'Ternary (Base3)': base3,
    'Quaternary (Base4)': base4,
    'Quinary (Base5)': base5,
    'Senary (Base6)': base6,
    'Octal (Base8)': base8,
    'Decimal (Base10)': base10,
    'Duodecimal (Base12)': base12,
    'Hexadecimal (Base16)': base16,
    'Base32': base32,
    'Base32Hex': base32hex,
    'Base36': base36,
    'Base58': base58,
    'Base62': base62,
    'Base64': base64,
    'Base64 URL': base64url,
  };

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
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'A Multiline String',
                hintText: 'Abdullah As-Sadeed',
              ),
              maxLines: null,
              showCursor: true,
              onChanged: (value) {
                setState(
                  () {
                    if (value.isNotEmpty) {
                      inputAsBase64 = base64Encode(
                        utf8.encode(value),
                      ).replaceAll('=', '');
                    }
                  },
                );
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a string!';
                }

                return null;
              },
              onFieldSubmitted: (value) {
                if (_formKey.currentState!.validate()) {
                  setState(
                    () {
                      if (value.isNotEmpty) {
                        inputAsBase64 = base64Encode(
                          utf8.encode(value),
                        ).replaceAll('=', '');
                      }
                    },
                  );
                }
              },
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          inputAsBase64.isEmpty
              ? const Text(
                  'Start typing a string to encode it into\nbinary (Base2),\nternary (Base3),\nquaternary (Base4),\nquinary (Base5),\nsenary (Base6),\noctal (Base8),\ndecimal (Base10),\nduodecimal (Base12),\nhexadecimal (Base16),\nBase32, Base32Hex,\nBase36,\nBase58,\nBase62,\nBase64, and Base64 URL.',
                )
              : Column(
                  children: encodings.entries.map(
                    (entry) {
                      String output;

                      try {
                        final converter = BaseConversion(
                          from: base64,
                          to: entry.value,
                          zeroPadding: true,
                        );
                        output = converter(inputAsBase64);
                      } catch (error) {
                        output = error.toString();
                      }

                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8,
                        ),
                        child: Card(
                          child: ListTile(
                            title: Text(entry.key),
                            subtitle: Text(output),
                            trailing: IconButton(
                              icon: const Icon(Icons.copy_rounded),
                              onPressed: () {
                                copyToClipBoard(
                                  context,
                                  entry.key,
                                  output,
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                )
        ],
      ),
    );
  }
}

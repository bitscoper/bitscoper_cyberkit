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
        title: Text(
          AppLocalizations.of(context)!.base_encoder,
        ),
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
                    if (value.isNotEmpty) {
                      inputAsBase64 = base64Encode(
                        utf8.encode(value),
                      ).replaceAll('=', '');
                    }
                  },
                );
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
          if (inputAsBase64.isEmpty)
            Center(
              child: Column(
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!
                        .start_typing_a_string_to_encode_it_into_the_bases,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Wrap(
                    alignment: WrapAlignment.center,
                    children: <Widget>[
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Binary (Base2)'),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Ternary (Base3)'),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Quaternary (Base4)'),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Quinary (Base5)'),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Senary (Base6)'),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Octal (Base8)'),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Decimal (Base10)'),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Duodecimal (Base12)'),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Hexadecimal (Base16)'),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Base32'),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Base32Hex'),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Base36'),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Base58'),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Base62'),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Base64'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          else
            Column(
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

// TODO: Add Bulk Save Button

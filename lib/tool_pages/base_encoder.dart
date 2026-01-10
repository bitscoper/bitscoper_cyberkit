/* By Abdullah As-Sadeed */

import 'dart:convert';
import 'package:b/b.dart';
import 'package:bitscoper_cyberkit/commons/application_toolbar.dart';
import 'package:bitscoper_cyberkit/commons/copy_to_clipboard.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:flutter/material.dart';

class BaseEncoderPage extends StatefulWidget {
  const BaseEncoderPage({super.key});

  @override
  BaseEncoderPageState createState() => BaseEncoderPageState();
}

class BaseEncoderPageState extends State<BaseEncoderPage> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _stringEditingController =
      TextEditingController();

  late String _stringAsBase64;

  final Map<String, String> bases = {
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

  void _encodeStringToBase64() {
    try {
      setState(() {
        if (_formKey.currentState!.validate()) {
          _stringAsBase64 = base64Encode(
            utf8.encode(_stringEditingController.text),
          ).replaceAll('=', '');
        }
      });
    } catch (error) {
      showMessageDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );
    } finally {}
  }

  @override
  void dispose() {
    _stringEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(context)!.base_encoder,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _stringEditingController,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)!.a_multiline_string,
                  hintText: AppLocalizations.of(context)!.abdullah_as_sadeed,
                ),
                showCursor: true,
                maxLines: null,
                validator: (String? value) {
                  if ((value == null) || value.isEmpty) {
                    return AppLocalizations.of(context)!.enter_a_string;
                  }

                  return null;
                },
                onChanged: (String value) {
                  _encodeStringToBase64();
                },
                onFieldSubmitted: (String value) {
                  _encodeStringToBase64();
                },
              ),
            ),
            const SizedBox(height: 16.0),
            if (_stringEditingController.text.isEmpty)
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(
                        context,
                      )!.start_typing_a_string_to_encode_it_into_the_bases,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8.0),
                    const Wrap(
                      alignment: WrapAlignment.center,
                      children: <Widget>[
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Binary (Base2)'),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Ternary (Base3)'),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Quaternary (Base4)'),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Quinary (Base5)'),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Senary (Base6)'),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Octal (Base8)'),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Decimal (Base10)'),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Duodecimal (Base12)'),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Hexadecimal (Base16)'),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Base32'),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Base32Hex'),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Base36'),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Base58'),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Base62'),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: bases.entries.map((MapEntry<String, String> entry) {
                  String result = '';

                  try {
                    final converter = BaseConversion(
                      from: base64,
                      to: entry.value,
                      zeroPadding: true,
                    );
                    result = converter(_stringAsBase64);
                  } catch (error) {
                    showMessageDialog(
                      AppLocalizations.of(context)!.error,
                      error.toString(),
                    );
                  } finally {}

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Card(
                      child: ListTile(
                        title: Text(entry.key),
                        subtitle: Text(result),
                        trailing: IconButton(
                          icon: const Icon(Icons.copy_rounded),
                          onPressed: () {
                            try {
                              copyToClipboard(entry.key, result);
                            } catch (error) {
                              showMessageDialog(
                                AppLocalizations.of(context)!.error,
                                error.toString(),
                              );
                            } finally {}
                          },
                          tooltip: AppLocalizations.of(
                            context,
                          )!.copy_to_clipboard,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

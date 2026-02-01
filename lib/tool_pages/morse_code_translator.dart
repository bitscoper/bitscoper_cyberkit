/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyberkit/commons/application_toolbar.dart';
import 'package:bitscoper_cyberkit/commons/copy_to_clipboard.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morse_code_translator/morse_code_translator.dart';

class MorseCodeTranslatorPage extends StatefulWidget {
  const MorseCodeTranslatorPage({super.key});

  @override
  MorseCodeTranslatorPageState createState() => MorseCodeTranslatorPageState();
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class MorseCodeTranslatorPageState extends State<MorseCodeTranslatorPage> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormState> _stringFormKey = GlobalKey<FormState>(),
      _morseCodeFormKey = GlobalKey<FormState>();
  final TextEditingController _stringEditingController =
          TextEditingController(),
      _morseCodeController = TextEditingController();

  final MorseCode _translator = MorseCode();

  void _encodeString() {
    try {
      setState(() {
        if (_stringFormKey.currentState!.validate()) {
          _morseCodeController.text = _translator.enCode(
            _stringEditingController.text,
          );

          _morseCodeFormKey.currentState!.validate();
        }
      });
    } catch (error) {
      showMessageDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );
    } finally {}
  }

  void _decodeMorseCode() {
    try {
      setState(() {
        if (_morseCodeFormKey.currentState!.validate()) {
          _stringEditingController.text = _translator.deCode(
            _morseCodeController.text,
          );

          _stringFormKey.currentState!.validate();
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
    _morseCodeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(context)!.morse_code_translator,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              key: _stringFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _stringEditingController,
                    keyboardType: TextInputType.text,
                    inputFormatters: [UpperCaseTextFormatter()],
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)!.a_string,
                      hintText: AppLocalizations.of(
                        context,
                      )!.abdullah_as_sadeed.toUpperCase(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.copy_rounded),
                        onPressed: () {
                          try {
                            copyToClipboard(
                              AppLocalizations.of(context)!.string,
                              _stringEditingController.text,
                            );
                          } catch (error) {
                            showMessageDialog(
                              AppLocalizations.of(context)!.error,
                              error.toString(),
                            );
                          } finally {}
                        },
                      ),
                    ),
                    showCursor: true,
                    maxLines: null,
                    validator: (String? value) {
                      if ((value == null) || value.isEmpty) {
                        return AppLocalizations.of(context)!.enter_a_string;
                      }

                      return null;
                    },
                    onChanged: (String? value) {
                      _encodeString();
                    },
                    onFieldSubmitted: (String value) {
                      _encodeString();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Form(
              key: _morseCodeFormKey,
              child: TextFormField(
                controller: _morseCodeController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)!.morse_code,
                  hintText:
                      '.- -... -.. ..- .-.. .-.. .- .... / .- ... -....- ... .- -.. . . -..',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.copy_rounded),
                    onPressed: () {
                      try {
                        copyToClipboard(
                          AppLocalizations.of(context)!.morse_code,
                          _morseCodeController.text,
                        );
                      } catch (error) {
                        showMessageDialog(
                          AppLocalizations.of(context)!.error,
                          error.toString(),
                        );
                      } finally {}
                    },
                  ),
                ),
                showCursor: true,
                maxLines: null,
                validator: (String? value) {
                  if ((value == null) || value.isEmpty) {
                    return AppLocalizations.of(context)!.enter_morse_code;
                  }

                  return null;
                },
                onChanged: (String? value) {
                  _decodeMorseCode();
                },
                onFieldSubmitted: (String value) {
                  _decodeMorseCode();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

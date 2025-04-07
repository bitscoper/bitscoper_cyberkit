/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyber_toolbox/application_toolbar.dart';
import 'package:bitscoper_cyber_toolbox/l10n/app_localizations.dart';
import 'package:bitscoper_cyber_toolbox/main.dart';
import 'package:bitscoper_cyber_toolbox/message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:morse_code_translator/morse_code_translator.dart';

class MorseCodeTranslatorPage extends StatelessWidget {
  const MorseCodeTranslatorPage({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(context)!.morse_code_translator,
      ),
      body: const MorseCodeTranslatorBody(),
    );
  }
}

class MorseCodeTranslatorBody extends StatefulWidget {
  const MorseCodeTranslatorBody({super.key});

  @override
  MorseCodeTranslatorBodyState createState() => MorseCodeTranslatorBodyState();
}

class MorseCodeTranslatorBodyState extends State<MorseCodeTranslatorBody> {
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
      setState(
        () {
          if (_stringFormKey.currentState!.validate()) {
            _morseCodeController.text =
                _translator.enCode(_stringEditingController.text);

            _morseCodeFormKey.currentState!.validate();
          }
        },
      );
    } catch (error) {
      showMessageDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );
    }
  }

  void _decodeMorseCode() {
    try {
      setState(
        () {
          if (_morseCodeFormKey.currentState!.validate()) {
            _stringEditingController.text =
                _translator.deCode(_morseCodeController.text);

            _stringFormKey.currentState!.validate();
          }
        },
      );
    } catch (error) {
      showMessageDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );
    }
  }

  @override
  void dispose() {
    _stringEditingController.dispose();
    _morseCodeController.dispose();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Form(
            key: _stringFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _stringEditingController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.a_string,
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
                    String? value,
                  ) {
                    _encodeString();
                  },
                  onFieldSubmitted: (
                    String value,
                  ) {
                    _encodeString();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
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
              ),
              showCursor: true,
              maxLines: null,
              validator: (
                String? value,
              ) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.enter_morse_code;
                }

                return null;
              },
              onChanged: (
                String? value,
              ) {
                _decodeMorseCode();
              },
              onFieldSubmitted: (
                String value,
              ) {
                _decodeMorseCode();
              },
            ),
          )
        ],
      ),
    );
  }
}

// TODO: Add Copy Buttons

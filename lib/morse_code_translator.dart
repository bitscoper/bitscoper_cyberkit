/* By Abdullah As-Sadeed */

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:morse_code_translator/morse_code_translator.dart';

class MorseCodeTranslatorPage extends StatelessWidget {
  const MorseCodeTranslatorPage({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.morse_code_translator),
        centerTitle: true,
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
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _stringController;
  late TextEditingController _morseCodeController;

  final MorseCode translator = MorseCode();

  @override
  void initState() {
    super.initState();
    _stringController = TextEditingController();
    _morseCodeController = TextEditingController();
  }

  @override
  void dispose() {
    _stringController.dispose();
    _morseCodeController.dispose();
    super.dispose();
  }

  void encodeString(
    String string,
  ) {
    _morseCodeController.text = translator.enCode(string);
  }

  void decodeMorseCode(
    String morseCode,
  ) {
    _stringController.text = translator.deCode(morseCode);
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _stringController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'A String',
                hintText: 'Abdullah As-Sadeed',
              ),
              maxLines: null,
              showCursor: true,
              onChanged: encodeString,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a string!';
                }
                return null;
              },
              onFieldSubmitted: (value) {
                if (_formKey.currentState!.validate()) {
                  encodeString(value);
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _morseCodeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Morse Code',
                hintText:
                    '.- -... -.. ..- .-.. .-.. .- .... / .- ... -....- ... .- -.. . . -..',
              ),
              maxLines: null,
              showCursor: true,
              onChanged: decodeMorseCode,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a morse code!';
                }
                return null;
              },
              onFieldSubmitted: (value) {
                if (_formKey.currentState!.validate()) {
                  decodeMorseCode(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

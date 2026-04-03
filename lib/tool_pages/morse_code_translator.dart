/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyberkit/commons/application_toolbar.dart';
import 'package:bitscoper_cyberkit/commons/copy_to_clipboard.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morse_code_translator/morse_code_translator.dart';

class MorseCodeTranslatorPage extends ConsumerStatefulWidget {
  const MorseCodeTranslatorPage({super.key});

  @override
  ConsumerState<MorseCodeTranslatorPage> createState() {
    return _MorseCodeTranslatorPageState();
  }
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

final Provider<MorseCode> morseCodeTranslatorProvider =
    Provider.autoDispose<MorseCode>((Ref ref) {
      return MorseCode();
    });

final Provider<TextEditingController> stringEditingControllerProvider =
    Provider.autoDispose<TextEditingController>((Ref ref) {
      final TextEditingController controller = TextEditingController();
      ref.onDispose(controller.dispose);

      return controller;
    });

final Provider<TextEditingController> morseCodeEditingControllerProvider =
    Provider.autoDispose<TextEditingController>((Ref ref) {
      final TextEditingController controller = TextEditingController();
      ref.onDispose(controller.dispose);

      return controller;
    });

class _MorseCodeTranslatorPageState
    extends ConsumerState<MorseCodeTranslatorPage> {
  final GlobalKey<FormState> _stringFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _morseCodeFormKey = GlobalKey<FormState>();

  String? _stringFieldValidator(BuildContext context, String? value) {
    if ((value == null) || value.isEmpty) {
      return AppLocalizations.of(context)!.enter_a_string;
    } else {
      return null;
    }
  }

  void _encode(BuildContext context) {
    try {
      if (_stringFormKey.currentState!.validate()) {
        final MorseCode translator = ref.read(morseCodeTranslatorProvider);
        final TextEditingController stringEditingController = ref.read(
          stringEditingControllerProvider,
        );
        final TextEditingController morseCodeEditingController = ref.read(
          morseCodeEditingControllerProvider,
        );

        morseCodeEditingController.text = translator.enCode(
          stringEditingController.text,
        );

        _morseCodeFormKey.currentState!.validate();
      }
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(AppLocalizations.of(context)!.error, error.toString());
    } finally {}
  }

  String? _morseCodeFieldValidator(BuildContext context, String? value) {
    if ((value == null) || value.isEmpty) {
      return AppLocalizations.of(context)!.enter_morse_code;
    } else {
      return null;
    }
  }

  void _decode(BuildContext context) {
    try {
      if (_morseCodeFormKey.currentState!.validate()) {
        final MorseCode translator = ref.read(morseCodeTranslatorProvider);
        final TextEditingController stringEditingController = ref.read(
          stringEditingControllerProvider,
        );
        final TextEditingController morseCodeEditingController = ref.read(
          morseCodeEditingControllerProvider,
        );

        stringEditingController.text = translator.deCode(
          morseCodeEditingController.text,
        );

        _stringFormKey.currentState!.validate();
      }
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(AppLocalizations.of(context)!.error, error.toString());
    } finally {}
  }

  Widget _stringForm(BuildContext context) {
    final TextEditingController editingController = ref.watch(
      stringEditingControllerProvider,
    );

    return Form(
      key: _stringFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: editingController,
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
                  copyToClipboard(
                    AppLocalizations.of(context)!.string,
                    editingController.text,
                  );
                },
              ),
            ),
            showCursor: true,
            maxLines: null,
            validator: (String? value) {
              return _stringFieldValidator(context, value);
            },
            onChanged: (String? value) {
              _encode(context);
            },
            onFieldSubmitted: (String value) {
              _encode(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _morseCodeForm(BuildContext context) {
    final TextEditingController editingController = ref.watch(
      morseCodeEditingControllerProvider,
    );

    return Form(
      key: _morseCodeFormKey,
      child: TextFormField(
        controller: editingController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: AppLocalizations.of(context)!.morse_code,
          hintText:
              '.- -... -.. ..- .-.. .-.. .- .... / .- ... -....- ... .- -.. . . -..',
          suffixIcon: IconButton(
            icon: const Icon(Icons.copy_rounded),
            onPressed: () {
              copyToClipboard(
                AppLocalizations.of(context)!.morse_code,
                editingController.text,
              );
            },
          ),
        ),
        showCursor: true,
        maxLines: null,
        validator: (String? value) {
          return _morseCodeFieldValidator(context, value);
        },
        onChanged: (String? value) {
          _decode(context);
        },
        onFieldSubmitted: (String value) {
          _decode(context);
        },
      ),
    );
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
            _stringForm(context),
            const SizedBox(height: 16.0),
            _morseCodeForm(context),
          ],
        ),
      ),
    );
  }
}

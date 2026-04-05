/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyberkit/commons/application_toolbar.dart';
import 'package:bitscoper_cyberkit/commons/copy_to_clipboard.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morse_code_translator/morse_code_translator.dart';

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

class MorseCodeTranslatorPage extends ConsumerWidget {
  const MorseCodeTranslatorPage({super.key});

  String? _stringFieldValidator(BuildContext context, String? value) {
    if ((value == null) || value.isEmpty) {
      return AppLocalizations.of(context)!.enter_a_string;
    } else {
      return null;
    }
  }

  String? _morseCodeFieldValidator(BuildContext context, String? value) {
    if ((value == null) || value.isEmpty) {
      return AppLocalizations.of(context)!.enter_morse_code;
    } else {
      return null;
    }
  }

  void _encode(BuildContext context, WidgetRef ref) {
    try {
      final MorseCode translator = ref.read(morseCodeTranslatorProvider);
      final TextEditingController stringEditingController = ref.read(
        stringEditingControllerProvider,
      );
      final TextEditingController morseCodeEditingController = ref.read(
        morseCodeEditingControllerProvider,
      );

      if (stringEditingController.text.isNotEmpty) {
        morseCodeEditingController.text = translator.enCode(
          stringEditingController.text,
        );
      } else {
        morseCodeEditingController.text = "";
      }
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(
        context,
        AppLocalizations.of(context)!.error,
        error.toString(),
      );
    }
  }

  void _decode(BuildContext context, WidgetRef ref) {
    try {
      final MorseCode translator = ref.read(morseCodeTranslatorProvider);
      final TextEditingController stringEditingController = ref.read(
        stringEditingControllerProvider,
      );
      final TextEditingController morseCodeEditingController = ref.read(
        morseCodeEditingControllerProvider,
      );

      if (morseCodeEditingController.text.isNotEmpty) {
        stringEditingController.text = translator.deCode(
          morseCodeEditingController.text,
        );
      } else {
        stringEditingController.text = "";
      }
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(
        context,
        AppLocalizations.of(context)!.error,
        error.toString(),
      );
    } finally {}
  }

  Widget _stringForm(BuildContext context, WidgetRef ref) {
    final TextEditingController editingController = ref.watch(
      stringEditingControllerProvider,
    );

    return Form(
      child: TextFormField(
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
                context,
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
          _encode(context, ref);
        },
        onFieldSubmitted: (String value) {
          _encode(context, ref);
        },
      ),
    );
  }

  Widget _morseCodeForm(BuildContext context, WidgetRef ref) {
    final TextEditingController editingController = ref.watch(
      morseCodeEditingControllerProvider,
    );

    return Form(
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
                context,
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
          _decode(context, ref);
        },
        onFieldSubmitted: (String value) {
          _decode(context, ref);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(context)!.morse_code_translator,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _stringForm(context, ref),
            const SizedBox(height: 16.0),
            _morseCodeForm(context, ref),
          ],
        ),
      ),
    );
  }
}

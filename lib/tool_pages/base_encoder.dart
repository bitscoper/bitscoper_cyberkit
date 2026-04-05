/* By Abdullah As-Sadeed */

import 'dart:convert';
import 'package:b/b.dart';
import 'package:bitscoper_cyberkit/commons/application_toolbar.dart';
import 'package:bitscoper_cyberkit/commons/copy_to_clipboard.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final NotifierProvider<StringNotifier, String> stringNotifierProvider =
    NotifierProvider.autoDispose<StringNotifier, String>(() {
      return StringNotifier();
    });

class StringNotifier extends Notifier<String> {
  late final TextEditingController controller;

  @override
  String build() {
    controller = TextEditingController();
    controller.addListener(() {
      state = controller.text;
    });

    ref.onDispose(controller.dispose);

    return "";
  }
}

final Provider<Map<String, String>> basesProvider =
    Provider<Map<String, String>>(
      (Ref ref) => {
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
      },
    );

class BaseEncoderPage extends ConsumerWidget {
  const BaseEncoderPage({super.key});

  String? _stringFieldValidator(BuildContext context, String? value) {
    if ((value == null) || value.isEmpty) {
      return AppLocalizations.of(context)!.enter_a_string;
    } else {
      return null;
    }
  }

  String _encodeStringToBase64(BuildContext context, String string) {
    try {
      if (string.isNotEmpty) {
        return base64Encode(utf8.encode(string)).replaceAll("=", "");
      } else {
        return "";
      }
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(
        context,
        AppLocalizations.of(context)!.error,
        error.toString(),
      );

      return "";
    } finally {}
  }

  Widget _form(BuildContext context, WidgetRef ref) {
    final StringNotifier notifier = ref.read(stringNotifierProvider.notifier);
    final TextEditingController editingController = notifier.controller;

    return Form(
      child: TextFormField(
        controller: editingController,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: AppLocalizations.of(context)!.a_multiline_string,
          hintText: AppLocalizations.of(context)!.abdullah_as_sadeed,
        ),
        showCursor: true,
        maxLines: null,
        validator: (String? value) {
          return _stringFieldValidator(context, value);
        },
        onChanged: (String value) {},
        onFieldSubmitted: (String value) {},
      ),
    );
  }

  Widget _startNotice(BuildContext context) {
    return Center(
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
    );
  }

  Widget _resultColumn(BuildContext context, WidgetRef ref, String string) {
    if (string.isNotEmpty) {
      final Map<String, String> bases = ref.watch(basesProvider);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: bases.entries.map((MapEntry<String, String> entry) {
          String result = "";

          try {
            final BaseConversion converter = BaseConversion(
              from: base64,
              to: entry.value,
              zeroPadding: true,
            );
            result = converter(_encodeStringToBase64(context, string));
          } catch (error) {
            debugPrint(error.toString());

            showMessageDialog(
              context,
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
                    copyToClipboard(context, entry.key, result);
                  },
                  tooltip: AppLocalizations.of(context)!.copy_to_clipboard,
                ),
              ),
            ),
          );
        }).toList(),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String string = ref.watch(stringNotifierProvider);

    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(context)!.base_encoder,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _form(context, ref),
            const SizedBox(height: 16.0),
            string.isNotEmpty
                ? _resultColumn(context, ref, string)
                : _startNotice(context),
          ],
        ),
      ),
    );
  }
}

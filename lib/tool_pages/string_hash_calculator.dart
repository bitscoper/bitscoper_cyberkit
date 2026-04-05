/* By Abdullah As-Sadeed */

import 'dart:convert';
import 'dart:typed_data';
import 'package:bitscoper_cyberkit/commons/application_toolbar.dart';
import 'package:bitscoper_cyberkit/commons/copy_to_clipboard.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:crypto/crypto.dart';
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

final Provider<Map<String, String>> hashProvider =
    Provider<Map<String, String>>((Ref ref) {
      try {
        final String string = ref.watch(stringNotifierProvider);

        if (string.isNotEmpty) {
          final Uint8List bytes = utf8.encode(string);

          return {
            'MD5': md5.convert(bytes).toString(),
            'SHA1': sha1.convert(bytes).toString(),
            'SHA224': sha224.convert(bytes).toString(),
            'SHA256': sha256.convert(bytes).toString(),
            'SHA384': sha384.convert(bytes).toString(),
            'SHA512': sha512.convert(bytes).toString(),
          };
        } else {
          return {};
        }
      } catch (error) {
        debugPrint(error.toString());

        showMessageDialog(
          navigatorKey.currentContext!,
          AppLocalizations.of(navigatorKey.currentContext!)!.error,
          error.toString(),
        );

        return {};
      } finally {}
    });

class StringHashCalculatorPage extends ConsumerWidget {
  const StringHashCalculatorPage({super.key});

  String? _stringFieldValidator(BuildContext context, String? value) {
    if ((value == null) || value.isEmpty) {
      return AppLocalizations.of(context)!.enter_a_string;
    } else {
      return null;
    }
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
      child: Text(
        AppLocalizations.of(
          context,
        )!.start_typing_a_string_to_calculate_its_md5_sha1_sha224_sha256_sha384_sha512_hashes,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _resultColumn(
    BuildContext context,
    WidgetRef ref,
    Map<String, String> hashes,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: hashes.entries.map((MapEntry<String, String> entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Card(
            child: ListTile(
              title: Text(entry.key),
              subtitle: Text(entry.value),
              trailing: IconButton(
                icon: const Icon(Icons.copy_rounded),
                onPressed: () {
                  copyToClipboard(
                    context,
                    "${entry.key} ${AppLocalizations.of(context)!.hash}",
                    entry.value,
                  );
                },
                tooltip: AppLocalizations.of(context)!.copy_to_clipboard,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String string = ref.watch(stringNotifierProvider);
    final Map<String, String> hashes = ref.watch(hashProvider);

    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(context)!.string_hash_calculator,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _form(context, ref),
            const SizedBox(height: 16.0),
            string.isNotEmpty
                ? _resultColumn(context, ref, hashes)
                : _startNotice(context),
          ],
        ),
      ),
    );
  }
}

/* By Abdullah As-Sadeed */

import 'dart:io';
import 'dart:typed_data';
import 'package:bitscoper_cyberkit/commons/application_toolbar.dart';
import 'package:bitscoper_cyberkit/commons/copy_to_clipboard.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/commons/notification_sender.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final NotifierProvider<HashNotifier, List<Map<String, dynamic>>>
hashesNotifierProvider =
    NotifierProvider.autoDispose<HashNotifier, List<Map<String, dynamic>>>(() {
      return HashNotifier();
    });

class HashNotifier extends Notifier<List<Map<String, dynamic>>> {
  bool _isCalculating = false;

  @override
  List<Map<String, dynamic>> build() {
    return <Map<String, dynamic>>[];
  }

  Future<void> _calculate(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
      );

      if (result != null) {
        final List<File> selectedFiles = result.paths
            .where((String? path) {
              return (path != null);
            })
            .map((String? path) {
              return File(path!);
            })
            .toList();

        _isCalculating = true;
        state = [...state];

        final List<Map<String, String>> hashes = await Future.wait(
          selectedFiles.map((File file) async {
            final Uint8List bytes = await file.readAsBytes();

            return {
              'File Name': file.path.split('/').last,
              'MD5': md5.convert(bytes).toString(),
              'SHA1': sha1.convert(bytes).toString(),
              'SHA224': sha224.convert(bytes).toString(),
              'SHA256': sha256.convert(bytes).toString(),
              'SHA384': sha384.convert(bytes).toString(),
              'SHA512': sha512.convert(bytes).toString(),
            };
          }),
        );

        state = hashes;
        _isCalculating = false;
        state = [...state];

        await sendNotification(
          title: AppLocalizations.of(
            navigatorKey.currentContext!,
          )!.file_hash_calculator,
          subtitle: AppLocalizations.of(
            navigatorKey.currentContext!,
          )!.bitscoper_cyberkit,
          body: AppLocalizations.of(navigatorKey.currentContext!)!.calculated,
          payload: "File_Hash_Calculator",
        );
      }
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(
        navigatorKey.currentContext!,
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );

      _isCalculating = false;
      state = [...state];
    } finally {}
  }
}

final Provider<bool> statusProvider = Provider<bool>((Ref ref) {
  ref.watch(hashesNotifierProvider);
  return ref.watch(hashesNotifierProvider.notifier)._isCalculating;
});

class FileHashCalculatorPage extends ConsumerWidget {
  const FileHashCalculatorPage({super.key});

  Widget _form(BuildContext context, WidgetRef ref) {
    final HashNotifier notifier = ref.read(hashesNotifierProvider.notifier);

    return Form(
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            notifier._calculate(context);
          },
          child: Text(AppLocalizations.of(context)!.select_files),
        ),
      ),
    );
  }

  Widget _startNotice(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(
          context,
        )!.select_files_to_calculate_their_md5_sha1_sha224_sha256_sha384_sha512_hashes,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _resultColumn(
    BuildContext context,
    List<Map<String, dynamic>> hashes,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (Map<String, dynamic> hash in hashes)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: Center(
                      child: Text(
                        hash['File Name'],
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  for (MapEntry<String, dynamic> entry in hash.entries)
                    if (entry.key != 'File Name')
                      ListTile(
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
                          tooltip: AppLocalizations.of(
                            context,
                          )!.copy_to_clipboard,
                        ),
                      ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Map<String, dynamic>> hashes = ref.watch(hashesNotifierProvider);
    final bool isCalculating = ref.watch(statusProvider);

    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(context)!.file_hash_calculator,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _form(context, ref),
            const SizedBox(height: 16.0),
            if (!isCalculating && hashes.isEmpty)
              _startNotice(context)
            else if (isCalculating)
              const Center(child: CircularProgressIndicator())
            else
              _resultColumn(context, hashes),
          ],
        ),
      ),
    );
  }
}

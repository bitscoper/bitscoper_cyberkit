/* By Abdullah As-Sadeed */

import 'dart:io';
import 'package:bitscoper_cyber_toolbox/application_toolbar.dart';
import 'package:bitscoper_cyber_toolbox/copy_to_clipboard.dart';
import 'package:bitscoper_cyber_toolbox/main.dart';
import 'package:bitscoper_cyber_toolbox/message_dialog.dart';
import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FileHashCalculatorPage extends StatelessWidget {
  const FileHashCalculatorPage({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(context)!.file_hash_calculator,
      ),
      body: const FileHashCalculatorBody(),
    );
  }
}

class FileHashCalculatorBody extends StatefulWidget {
  const FileHashCalculatorBody({super.key});

  @override
  FileHashCalculatorBodyState createState() => FileHashCalculatorBodyState();
}

class FileHashCalculatorBodyState extends State<FileHashCalculatorBody> {
  @override
  void initState() {
    super.initState();
  }

  bool _isCalculating = false;
  List<Map<String, dynamic>> _hashValues = [];

  Future<void> _calculateHashes(
    List<File> files,
  ) async {
    try {
      setState(
        () {
          _isCalculating = true;
        },
      );

      final List<Map<String, String>> hashValues = await Future.wait(
        files.map(
          (
            File file,
          ) async {
            final Uint8List bytes = await file.readAsBytes();

            final String md5Hash = md5.convert(bytes).toString();
            final String sha1Hash = sha1.convert(bytes).toString();
            final String sha224Hash = sha224.convert(bytes).toString();
            final String sha512Hash = sha512.convert(bytes).toString();
            final String sha256Hash = sha256.convert(bytes).toString();
            final String sha384Hash = sha384.convert(bytes).toString();

            return {
              'File Name': file.path.split('/').last,
              'MD5': md5Hash,
              'SHA1': sha1Hash,
              'SHA224': sha224Hash,
              'SHA256': sha256Hash,
              'SHA384': sha384Hash,
              'SHA512': sha512Hash,
            };
          },
        ),
      );

      setState(
        () {
          _hashValues = hashValues;
        },
      );
    } catch (error) {
      showMessageDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );
    } finally {
      setState(
        () {
          _isCalculating = false;
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: ElevatedButton(
              child: Text(
                AppLocalizations.of(context)!.select_files,
              ),
              onPressed: () async {
                List<Uint8List> files = [];

                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.any,
                  allowMultiple: true,
                  dialogTitle: AppLocalizations.of(context)!.select_files,
                );

                if (result != null) {
                  List<File> selectedFiles = result.paths
                      .where(
                    (
                      String? path,
                    ) =>
                        path != null,
                  )
                      .map(
                    (
                      String? path,
                    ) {
                      return File(path!);
                    },
                  ).toList();

                  for (File file in selectedFiles) {
                    files.add(
                      file.readAsBytesSync(),
                    );
                  }

                  await _calculateHashes(selectedFiles);
                }
              },
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          if (!_isCalculating && _hashValues.isEmpty)
            Center(
              child: Text(
                AppLocalizations.of(context)!
                    .select_files_to_calculate_their_md5_sha1_sha224_sha256_sha384_sha512_hashes,
                textAlign: TextAlign.center,
              ),
            )
          else if (_isCalculating)
            const Center(
              child: CircularProgressIndicator(),
            )
          else
            Column(
              children: <Widget>[
                for (Map<String, dynamic> hashValue in _hashValues)
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16,
                    ),
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Center(
                              child: Text(
                                hashValue['File Name'],
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          for (MapEntry<String, dynamic> entry
                              in hashValue.entries)
                            if (entry.key != 'File Name')
                              ListTile(
                                title: Text(
                                  entry.key,
                                ),
                                subtitle: Text(
                                  entry.value,
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.copy_rounded),
                                  onPressed: () {
                                    copyToClipBoard(
                                      context,
                                      "${entry.key} ${AppLocalizations.of(context)!.hash}",
                                      entry.value,
                                    );
                                  },
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

// TODO: Add Bulk Save Button

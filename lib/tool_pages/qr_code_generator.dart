/* By Abdullah As-Sadeed */

import 'dart:typed_data';
import 'package:bitscoper_cyberkit/commons/application_toolbar.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class QRCodeGeneratorPage extends StatefulWidget {
  const QRCodeGeneratorPage({super.key});

  @override
  QRCodeGeneratorPageState createState() => QRCodeGeneratorPageState();
}

class QRCodeGeneratorPageState extends State<QRCodeGeneratorPage> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _stringEditingController =
      TextEditingController();
  final TextEditingController _paddingEditingController = TextEditingController(
    text: '16',
  );
  final WidgetsToImageController _widgetsToImageController =
      WidgetsToImageController();

  int _version = QrVersions.auto;
  int _errorCorrectionLevel = QrErrorCorrectLevel.H;
  Color _backgroundColor = Colors.white;
  QrEyeShape _eyeShape = QrEyeShape.square;
  QrDataModuleShape _dataModuleShape = QrDataModuleShape.square;
  Color _eyeColor = Colors.black;
  Color _dataModuleColor = Colors.black;
  bool _gaplessness = false;
  Uint8List? _embeddedImageBytes;
  final String _semanticsLabel = 'Generated QR Code';

  void _pickColor(
    BuildContext context,
    Color currentColor,
    Function(Color) onColorChanged,
  ) {
    try {
      Color pickerColor = currentColor;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.color_selection,
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: (Color color) {
                  pickerColor = color;
                },
              ),
            ),
            actions: <Widget>[
              Center(
                child: ElevatedButton(
                  child: Text(AppLocalizations.of(context)!.select),
                  onPressed: () {
                    try {
                      onColorChanged(pickerColor);
                      Navigator.of(context).pop();
                    } catch (error) {
                      debugPrint(error.toString());

                      showMessageDialog(
                        AppLocalizations.of(context)!.error,
                        error.toString(),
                      );
                    } finally {}
                  },
                ),
              ),
            ],
          );
        },
      );
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(AppLocalizations.of(context)!.error, error.toString());
    } finally {}
  }

  @override
  void dispose() {
    _stringEditingController.dispose();
    _paddingEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat numberFormat = NumberFormat(
      '#',
      AppLocalizations.of(context)!.localeName,
    );

    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(context)!.qr_code_generator,
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32.0),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Center(
              child: (_stringEditingController.text.isNotEmpty)
                  ? WidgetsToImage(
                      controller: _widgetsToImageController,
                      child: QrImageView(
                        version: _version,
                        errorCorrectionLevel: _errorCorrectionLevel,
                        backgroundColor: _backgroundColor,
                        padding: EdgeInsets.all(
                          double.tryParse(
                            _paddingEditingController.text.trim(),
                          )!,
                        ),
                        eyeStyle: QrEyeStyle(
                          eyeShape: _eyeShape,
                          color: _eyeColor,
                        ),
                        dataModuleStyle: QrDataModuleStyle(
                          dataModuleShape: _dataModuleShape,
                          color: _dataModuleColor,
                        ),
                        gapless: _gaplessness,
                        data: _stringEditingController.text,
                        embeddedImage: _embeddedImageBytes != null
                            ? MemoryImage(_embeddedImageBytes!, scale: 1.0)
                            : null,
                        embeddedImageEmitsError: true,
                        semanticsLabel: _semanticsLabel,
                      ),
                    )
                  : Text(
                      AppLocalizations.of(
                        context,
                      )!.start_typing_a_string_to_generate_qr_code,
                      textAlign: TextAlign.center,
                    ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
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
                        labelText: AppLocalizations.of(
                          context,
                        )!.a_multiline_string,
                        hintText: AppLocalizations.of(
                          context,
                        )!.abdullah_as_sadeed,
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
                        if (_formKey.currentState!.validate()) {
                          setState(() {});
                        }
                      },
                      onFieldSubmitted: (String value) {
                        if (_formKey.currentState!.validate()) {
                          setState(() {});
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          final FilePickerResult? filePickerResult =
                              await FilePicker.platform.pickFiles(
                                lockParentWindow: true,
                                dialogTitle: AppLocalizations.of(
                                  context,
                                )!.pick_an_image_file_to_embed_in_qr_code,
                                type: FileType.image,
                                allowMultiple: false,
                                readSequential: true,
                                withData: true,
                                compressionQuality: 0,
                              );

                          if (filePickerResult != null &&
                              filePickerResult.files.single.bytes != null) {
                            _embeddedImageBytes =
                                filePickerResult.files.single.bytes!;
                          }

                          setState(() {});
                        } catch (error) {
                          debugPrint(error.toString());

                          showMessageDialog(
                            AppLocalizations.of(
                              navigatorKey.currentContext!,
                            )!.error,
                            error.toString(),
                          );
                        } finally {}
                      },
                      icon: const Icon(Icons.image_rounded),
                      label: Text(AppLocalizations.of(context)!.embed_image),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.version,
                          ),
                          items: [
                            DropdownMenuItem(
                              value: QrVersions.auto,
                              child: Text(
                                AppLocalizations.of(context)!.automatic,
                              ),
                            ),
                            ...List.generate(40, (int index) => index + 1).map(
                              (int qrVersion) => DropdownMenuItem(
                                value: qrVersion,
                                child: Text(numberFormat.format(qrVersion)),
                              ),
                            ),
                          ],
                          initialValue: _version,
                          onChanged: (int? value) {
                            setState(() {
                              _version = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        flex: 1,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(
                              context,
                            )!.error_correction_level,
                          ),
                          items: [
                            DropdownMenuItem(
                              value: QrErrorCorrectLevel.H,
                              child: Text(AppLocalizations.of(context)!.high),
                            ),
                            DropdownMenuItem(
                              value: QrErrorCorrectLevel.Q,
                              child: Text(
                                AppLocalizations.of(context)!.quartile,
                              ),
                            ),
                            DropdownMenuItem(
                              value: QrErrorCorrectLevel.M,
                              child: Text(AppLocalizations.of(context)!.medium),
                            ),
                            DropdownMenuItem(
                              value: QrErrorCorrectLevel.L,
                              child: Text(AppLocalizations.of(context)!.low),
                            ),
                          ],
                          initialValue: _errorCorrectionLevel,
                          onChanged: (int? value) {
                            setState(() {
                              _errorCorrectionLevel = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.eye_shape,
                          ),
                          items: [
                            DropdownMenuItem(
                              value: QrEyeShape.square,
                              child: Text(AppLocalizations.of(context)!.square),
                            ),
                            DropdownMenuItem(
                              value: QrEyeShape.circle,
                              child: Text(AppLocalizations.of(context)!.circle),
                            ),
                          ],
                          initialValue: _eyeShape,
                          onChanged: (QrEyeShape? value) {
                            setState(() {
                              _eyeShape = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        flex: 1,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(
                              context,
                            )!.data_module_shape,
                          ),
                          items: [
                            DropdownMenuItem(
                              value: QrDataModuleShape.square,
                              child: Text(AppLocalizations.of(context)!.square),
                            ),
                            DropdownMenuItem(
                              value: QrDataModuleShape.circle,
                              child: Text(AppLocalizations.of(context)!.circle),
                            ),
                          ],
                          initialValue: _dataModuleShape,
                          onChanged: (QrDataModuleShape? value) {
                            setState(() {
                              _dataModuleShape = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    AppLocalizations.of(context)!.colors,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            try {
                              _pickColor(context, _eyeColor, (Color color) {
                                setState(() {
                                  _eyeColor = color;
                                });
                              });
                            } catch (error) {
                              showMessageDialog(
                                AppLocalizations.of(context)!.error,
                                error.toString(),
                              );
                            } finally {}
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              height: 32,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                                color: _eyeColor,
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.eye,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: useWhiteForeground(_eyeColor)
                                        ? Colors.white
                                        : DefaultTextStyle.of(
                                            context,
                                          ).style.color,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            try {
                              _pickColor(context, _dataModuleColor, (
                                Color color,
                              ) {
                                setState(() {
                                  _dataModuleColor = color;
                                });
                              });
                            } catch (error) {
                              showMessageDialog(
                                AppLocalizations.of(context)!.error,
                                error.toString(),
                              );
                            } finally {}
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              height: 32,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                                color: _dataModuleColor,
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.data,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: useWhiteForeground(_dataModuleColor)
                                        ? Colors.white
                                        : DefaultTextStyle.of(
                                            context,
                                          ).style.color,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            try {
                              _pickColor(context, _backgroundColor, (
                                Color color,
                              ) {
                                setState(() {
                                  _backgroundColor = color;
                                });
                              });
                            } catch (error) {
                              showMessageDialog(
                                AppLocalizations.of(context)!.error,
                                error.toString(),
                              );
                            } finally {}
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              height: 32,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                                color: _backgroundColor,
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.background,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: useWhiteForeground(_backgroundColor)
                                        ? Colors.white
                                        : DefaultTextStyle.of(
                                            context,
                                          ).style.color,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.gapless,
                          ),
                          items: [
                            DropdownMenuItem(
                              value: false,
                              child: Text(AppLocalizations.of(context)!.false_),
                            ),
                            DropdownMenuItem(
                              value: true,
                              child: Text(AppLocalizations.of(context)!.true_),
                            ),
                          ],
                          initialValue: _gaplessness,
                          onChanged: (Object? value) {
                            setState(() {
                              _gaplessness = value as bool;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: _paddingEditingController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.padding,
                            hintText: _paddingEditingController.text,
                          ),
                          showCursor: true,
                          maxLines: 1,
                          validator: (String? value) {
                            if ((value == null) || value.isEmpty) {
                              return AppLocalizations.of(
                                context,
                              )!.enter_padding;
                            } else if (double.tryParse(value) == null) {
                              return AppLocalizations.of(
                                context,
                              )!.enter_a_number;
                            } else if (double.tryParse(value)! < 1.toDouble()) {
                              return AppLocalizations.of(
                                context,
                              )!.enter_a_positive_number;
                            }

                            return null;
                          },
                          onChanged: (String value) {
                            if (_formKey.currentState!.validate()) {
                              setState(() {});
                            }
                          },
                          onFieldSubmitted: (String value) {
                            if (_formKey.currentState!.validate()) {
                              setState(() {});
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          if (_formKey.currentState!.validate()) {
                            final Uint8List? pngBytes =
                                await _widgetsToImageController.capture(
                                  options: const CaptureOptions(
                                    waitForAnimations: true,
                                    pixelRatio: 1.0,
                                    format: ImageFormat.png,
                                    quality: 100 /* For JPEG Only */,
                                  ),
                                );

                            if (pngBytes != null) {
                              String?
                              outputPath = await FilePicker.platform.saveFile(
                                lockParentWindow: true,
                                dialogTitle: AppLocalizations.of(
                                  navigatorKey.currentContext!,
                                )!.save_qr_code,
                                fileName:
                                    'QR_Code_${DateTime.now().millisecondsSinceEpoch}.png',
                                type: FileType.image,
                                bytes: pngBytes,
                              );

                              if (outputPath != null) {
                                ScaffoldMessenger.of(
                                  navigatorKey.currentContext!,
                                ).showSnackBar(
                                  SnackBar(
                                    content: Text("Saved: $outputPath"),
                                    showCloseIcon: true,
                                  ),
                                );
                              }
                            }
                          }
                        } catch (error) {
                          debugPrint(error.toString());
                          showMessageDialog(
                            AppLocalizations.of(
                              navigatorKey.currentContext!,
                            )!.error,
                            error.toString(),
                          );
                        }
                      },
                      icon: const Icon(Icons.save_rounded),
                      label: Text(AppLocalizations.of(context)!.save_qr_code),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

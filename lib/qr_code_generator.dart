/* By Abdullah As-Sadeed */

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeGeneratorPage extends StatelessWidget {
  const QRCodeGeneratorPage({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.qr_code_generator,
        ),
        centerTitle: true,
      ),
      body: const QRCodeGeneratorBody(),
    );
  }
}

class QRCodeGeneratorBody extends StatefulWidget {
  const QRCodeGeneratorBody({super.key});

  @override
  QRCodeGeneratorBodyState createState() => QRCodeGeneratorBodyState();
}

class QRCodeGeneratorBodyState extends State<QRCodeGeneratorBody> {
  final _formKey = GlobalKey<FormState>();

  int version = QrVersions.auto;
  int errorCorrectionLevel = QrErrorCorrectLevel.H;
  QrEyeShape eyeShape = QrEyeShape.square;
  QrDataModuleShape dataModuleShape = QrDataModuleShape.square;
  Color eyeColor = Colors.black;
  Color dataModuleColor = Colors.black;
  Color backgroundColor = Colors.white;
  bool gapless = false;
  double padding = 16;
  String semanticsLabel = 'Generated QR Code';
  String data = '';

  void pickColor(
    BuildContext context,
    Color currentColor,
    Function(Color) onColorChanged,
  ) {
    Color pickerColor = currentColor;

    showDialog(
      context: context,
      builder: (
        BuildContext context,
      ) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.color_selection,
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (
                Color color,
              ) {
                pickerColor = color;
              },
            ),
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                child: Text(AppLocalizations.of(context)!.select),
                onPressed: () {
                  onColorChanged(pickerColor);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final numberFormat =
        NumberFormat('#', AppLocalizations.of(context)!.localeName);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Form(
            key: _formKey,
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: AppLocalizations.of(context)!.a_multiline_string,
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
                String value,
              ) {
                setState(
                  () {
                    data = value;
                  },
                );
              },
              onFieldSubmitted: (
                String value,
              ) {
                if (_formKey.currentState!.validate()) {
                  setState(
                    () {
                      data = value;
                    },
                  );
                }
              },
            ),
          ),
          const SizedBox(
            height: 16,
          ),
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
                      child: Text(AppLocalizations.of(context)!.automatic),
                    ),
                    ...List.generate(
                      40,
                      (index) => index + 1,
                    ).map(
                      (qrVersion) => DropdownMenuItem(
                        value: qrVersion,
                        child: Text(
                          numberFormat.format(qrVersion),
                        ),
                      ),
                    ),
                  ],
                  value: version,
                  onChanged: (
                    int? value,
                  ) {
                    setState(
                      () {
                        version = value!;
                      },
                    );
                  },
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                flex: 1,
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)!.error_correction_level,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: QrErrorCorrectLevel.H,
                      child: Text(AppLocalizations.of(context)!.high),
                    ),
                    DropdownMenuItem(
                      value: QrErrorCorrectLevel.Q,
                      child: Text(AppLocalizations.of(context)!.quartile),
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
                  value: errorCorrectionLevel,
                  onChanged: (
                    int? value,
                  ) {
                    setState(
                      () {
                        errorCorrectionLevel = value!;
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
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
                  value: eyeShape,
                  onChanged: (
                    QrEyeShape? value,
                  ) {
                    setState(
                      () {
                        eyeShape = value!;
                      },
                    );
                  },
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                flex: 1,
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.data_module_shape,
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
                  value: dataModuleShape,
                  onChanged: (
                    QrDataModuleShape? value,
                  ) {
                    setState(
                      () {
                        dataModuleShape = value!;
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            AppLocalizations.of(context)!.colors,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    pickColor(
                      context,
                      eyeColor,
                      (
                        Color color,
                      ) {
                        setState(
                          () {
                            eyeColor = color;
                          },
                        );
                      },
                    );
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
                        borderRadius: BorderRadius.circular(4),
                        color: eyeColor,
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.eye,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: useWhiteForeground(eyeColor)
                                ? Colors.white
                                : DefaultTextStyle.of(context).style.color,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    pickColor(
                      context,
                      dataModuleColor,
                      (
                        Color color,
                      ) {
                        setState(
                          () {
                            dataModuleColor = color;
                          },
                        );
                      },
                    );
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
                        borderRadius: BorderRadius.circular(4),
                        color: dataModuleColor,
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.data,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: useWhiteForeground(dataModuleColor)
                                ? Colors.white
                                : DefaultTextStyle.of(context).style.color,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    pickColor(
                      context,
                      backgroundColor,
                      (
                        Color color,
                      ) {
                        setState(
                          () {
                            backgroundColor = color;
                          },
                        );
                      },
                    );
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
                        borderRadius: BorderRadius.circular(4),
                        color: backgroundColor,
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.background,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: useWhiteForeground(backgroundColor)
                                ? Colors.white
                                : DefaultTextStyle.of(context).style.color,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
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
                  value: gapless,
                  onChanged: (
                    Object? value,
                  ) {
                    setState(
                      () {
                        gapless = value as bool;
                      },
                    );
                  },
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                flex: 1,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.padding,
                    hintText: padding.toString(),
                  ),
                  showCursor: true,
                  maxLines: 1,
                  initialValue: padding.toString(),
                  validator: (
                    String? value,
                  ) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.enter_padding;
                    } else if (double.tryParse(value) == null) {
                      return AppLocalizations.of(context)!.enter_a_number;
                    } else if (double.tryParse(value)! < 1.toDouble()) {
                      return AppLocalizations.of(context)!
                          .enter_a_positive_number;
                    }

                    return null;
                  },
                  onChanged: (
                    String value,
                  ) {
                    if (_formKey.currentState!.validate()) {
                      setState(
                        () {
                          padding = double.tryParse(
                                value.trim(),
                              ) ??
                              padding;
                        },
                      );
                    }
                  },
                  onFieldSubmitted: (
                    String value,
                  ) {
                    if (_formKey.currentState!.validate()) {
                      setState(
                        () {
                          padding = double.tryParse(
                                value.trim(),
                              ) ??
                              padding;
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 96,
              bottom: 80, // 80 = (96 - 16)
            ),
            child: Center(
              child: Column(
                children: <Widget>[
                  if (data.isNotEmpty)
                    QrImageView(
                      version: version,
                      errorCorrectionLevel: errorCorrectionLevel,
                      eyeStyle: QrEyeStyle(
                        eyeShape: eyeShape,
                        color: eyeColor,
                      ),
                      dataModuleStyle: QrDataModuleStyle(
                        dataModuleShape: dataModuleShape,
                        color: dataModuleColor,
                      ),
                      backgroundColor: backgroundColor,
                      gapless: gapless,
                      semanticsLabel: semanticsLabel,
                      data: data,
                      padding: EdgeInsets.all(padding),
                      size: MediaQuery.of(context).size.width * 0.5,
                    )
                  else
                    Text(
                      AppLocalizations.of(context)!
                          .start_typing_a_string_to_generate_qr_code,
                      textAlign: TextAlign.center,
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

  // TODO: Add EmbeddedImage
  // TODO: Add Save Button

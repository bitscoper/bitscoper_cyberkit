/* By Abdullah As-Sadeed */

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

  String string = '';

  @override
  Widget build(
    BuildContext context,
  ) {
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.enter_a_string;
                }

                return null;
              },
              onChanged: (value) {
                setState(
                  () {
                    string = value;
                  },
                );
              },
              onFieldSubmitted: (value) {
                if (_formKey.currentState!.validate()) {
                  setState(
                    () {
                      string = value;
                    },
                  );
                }
              },
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Center(
            child: Column(
              children: <Widget>[
                if (string.isNotEmpty)
                  // TODO: Add Options for Customization, Download, and Share
                  QrImageView(
                    version: QrVersions.auto,
                    errorCorrectionLevel: QrErrorCorrectLevel.H,
                    gapless: false,
                    // eyeStyle: QrEyeStyle(
                    //   eyeShape: QrEyeShape.square,
                    // ),
                    data: string,
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
        ],
      ),
    );
  }
}

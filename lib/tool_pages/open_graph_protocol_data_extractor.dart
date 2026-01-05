/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyberkit/commons/application_toolbar.dart';
import 'package:bitscoper_cyberkit/commons/copy_to_clipboard.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/commons/notification_sender.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:flutter/material.dart';
import 'package:ogp_data_extract/ogp_data_extract.dart';

class OGPDataExtractorPage extends StatefulWidget {
  const OGPDataExtractorPage({super.key});

  @override
  OGPDataExtractorPageState createState() => OGPDataExtractorPageState();
}

class OGPDataExtractorPageState extends State<OGPDataExtractorPage> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _hostEditingController = TextEditingController();

  bool _isRetrieving = false;
  OgpData? _ogpData;

  void _retrieveOGPData() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _isRetrieving = true;
          _ogpData = null;
        });

        _ogpData = await OgpDataExtract.execute(
          _hostEditingController.text.trim(),
        );

        await sendNotification(
          title: AppLocalizations.of(
            navigatorKey.currentContext!,
          )!.open_graph_protocol_data_extractor,
          subtitle: AppLocalizations.of(
            navigatorKey.currentContext!,
          )!.bitscoper_cyberkit,
          body: AppLocalizations.of(navigatorKey.currentContext!)!.extracted,
          payload: "Open_Graph_Protocol_Data_Extractor",
        );
      } catch (error) {
        showMessageDialog(
          AppLocalizations.of(navigatorKey.currentContext!)!.error,
          error.toString(),
        );
      } finally {
        setState(() {
          _isRetrieving = false;
        });
      }
    }
  }

  Widget _buildCard(String title, String? value) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(value ?? 'N/A'),
        trailing: IconButton(
          icon: const Icon(Icons.copy_rounded),
          onPressed: () {
            copyToClipboard(title, value ?? 'N/A');
          },
          tooltip: AppLocalizations.of(
            navigatorKey.currentContext!,
          )!.copy_to_clipboard,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hostEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(context)!.ogp_data_extractor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _hostEditingController,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: AppLocalizations.of(
                        context,
                      )!.a_host_or_ip_address,
                      hintText: 'https://bitscoper.dev/',
                    ),
                    showCursor: true,
                    maxLines: 1,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(
                          context,
                        )!.enter_a_host_or_ip_address;
                      }

                      return null;
                    },
                    onChanged: (String value) {},
                    onFieldSubmitted: (String value) {
                      _retrieveOGPData();
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: _isRetrieving
                          ? null
                          : () {
                              _retrieveOGPData();
                            },
                      child: Text(AppLocalizations.of(context)!.extract),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            if (_isRetrieving)
              const Center(child: CircularProgressIndicator())
            else if (_ogpData != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildCard('URL', _ogpData!.url),
                  _buildCard('Type', _ogpData!.type),
                  _buildCard('Title', _ogpData!.title),
                  _buildCard('Description', _ogpData!.description),
                  _buildCard('Image', _ogpData!.image),
                  _buildCard('Image (Secure URL)', _ogpData!.imageSecureUrl),
                  _buildCard('Image Type', _ogpData!.imageType),
                  _buildCard('Image Width', _ogpData!.imageWidth?.toString()),
                  _buildCard('Image Height', _ogpData!.imageHeight?.toString()),
                  _buildCard('Image Alt', _ogpData!.imageAlt),
                  _buildCard('Site Name', _ogpData!.siteName),
                  _buildCard('Determiner', _ogpData!.determiner),
                  _buildCard('Locale', _ogpData!.locale),
                  _buildCard('Locale (Alternate)', _ogpData!.localeAlternate),
                  _buildCard('Latitude', _ogpData!.latitude?.toString()),
                  _buildCard('Longitude', _ogpData!.longitude?.toString()),
                  _buildCard('Street Address', _ogpData!.streetAddress),
                  _buildCard('Locality', _ogpData!.locality),
                  _buildCard('Region', _ogpData!.region),
                  _buildCard('Postal Code', _ogpData!.postalCode),
                  _buildCard('Country Name', _ogpData!.countryName),
                  _buildCard('Email Address', _ogpData!.email),
                  _buildCard('Phone Number', _ogpData!.phoneNumber),
                  _buildCard('Fax Number', _ogpData!.faxNumber),
                  _buildCard('Video', _ogpData!.video),
                  _buildCard('Video (Secure URL)', _ogpData!.videoSecureUrl),
                  _buildCard('Video Height', _ogpData!.videoHeight?.toString()),
                  _buildCard('Video Width', _ogpData!.videoWidth?.toString()),
                  _buildCard('Video Type', _ogpData!.videoType),
                  _buildCard('Audio', _ogpData!.audio),
                  _buildCard('Audio (Secure URL)', _ogpData!.audioSecureUrl),
                  _buildCard('Audio Title', _ogpData!.audioTitle),
                  _buildCard('Audio Artist', _ogpData!.audioArtist),
                  _buildCard('Audio Album', _ogpData!.audioAlbum),
                  _buildCard('Audio Type', _ogpData!.audioType),
                  _buildCard(
                    'Facebook Administrators',
                    _ogpData!.fbAdmins is List<String>
                        ? (_ogpData!.fbAdmins as List<String>).join(', ')
                        : _ogpData!.fbAdmins,
                  ),
                  _buildCard('Facebook App ID', _ogpData!.fbAppId),
                  _buildCard('Twitter Card', _ogpData!.twitterCard),
                  _buildCard('Twitter Site', _ogpData!.twitterSite),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

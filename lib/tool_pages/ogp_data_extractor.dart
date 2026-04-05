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
  OGPDataExtractorPageState createState() {
    return OGPDataExtractorPageState();
  }
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

  String? _hostFieldValidator(BuildContext context, String? value) {
    if ((value == null) || value.isEmpty) {
      return AppLocalizations.of(context)!.enter_a_host_or_ip_address;
    } else {
      return null;
    }
  }

  void _retrieve() async {
    try {
      if (_formKey.currentState!.validate()) {
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
          )!.ogp_data_extractor,
          subtitle: AppLocalizations.of(
            navigatorKey.currentContext!,
          )!.bitscoper_cyberkit,
          body: AppLocalizations.of(navigatorKey.currentContext!)!.extracted,
          payload: "OGP_Data_Extractor",
        );
      }
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(
        navigatorKey.currentContext!,
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );
    } finally {
      setState(() {
        _isRetrieving = false;
      });
    }
  }

  Widget _buildCard(BuildContext context, String title, String? value) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(value ?? 'N/A'),
        trailing: IconButton(
          icon: const Icon(Icons.copy_rounded),
          onPressed: () {
            copyToClipboard(context, title, value ?? 'N/A');
          },
          tooltip: AppLocalizations.of(context)!.copy_to_clipboard,
        ),
      ),
    );
  }

  Widget _form(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _hostEditingController,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.a_host_or_ip_address,
              hintText: 'https://bitscoper.dev/',
            ),
            showCursor: true,
            maxLines: 1,
            validator: (String? value) {
              return _hostFieldValidator(context, value);
            },
            onChanged: (String value) {},
            onFieldSubmitted: (String value) {
              _retrieve();
            },
          ),
          const SizedBox(height: 16.0),
          Center(
            child: ElevatedButton(
              onPressed: _isRetrieving ? null : _retrieve,
              child: Text(AppLocalizations.of(context)!.extract),
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildCard(context, 'URL', _ogpData!.url),
        _buildCard(context, 'Type', _ogpData!.type),
        _buildCard(context, 'Title', _ogpData!.title),
        _buildCard(context, 'Description', _ogpData!.description),
        _buildCard(context, 'Image', _ogpData!.image),
        _buildCard(context, 'Image (Secure URL)', _ogpData!.imageSecureUrl),
        _buildCard(context, 'Image Type', _ogpData!.imageType),
        _buildCard(context, 'Image Width', _ogpData!.imageWidth?.toString()),
        _buildCard(context, 'Image Height', _ogpData!.imageHeight?.toString()),
        _buildCard(context, 'Image Alt', _ogpData!.imageAlt),
        _buildCard(context, 'Site Name', _ogpData!.siteName),
        _buildCard(context, 'Determiner', _ogpData!.determiner),
        _buildCard(context, 'Locale', _ogpData!.locale),
        _buildCard(context, 'Locale (Alternate)', _ogpData!.localeAlternate),
        _buildCard(context, 'Latitude', _ogpData!.latitude?.toString()),
        _buildCard(context, 'Longitude', _ogpData!.longitude?.toString()),
        _buildCard(context, 'Street Address', _ogpData!.streetAddress),
        _buildCard(context, 'Locality', _ogpData!.locality),
        _buildCard(context, 'Region', _ogpData!.region),
        _buildCard(context, 'Postal Code', _ogpData!.postalCode),
        _buildCard(context, 'Country Name', _ogpData!.countryName),
        _buildCard(context, 'Email Address', _ogpData!.email),
        _buildCard(context, 'Phone Number', _ogpData!.phoneNumber),
        _buildCard(context, 'Fax Number', _ogpData!.faxNumber),
        _buildCard(context, 'Video', _ogpData!.video),
        _buildCard(context, 'Video (Secure URL)', _ogpData!.videoSecureUrl),
        _buildCard(context, 'Video Height', _ogpData!.videoHeight?.toString()),
        _buildCard(context, 'Video Width', _ogpData!.videoWidth?.toString()),
        _buildCard(context, 'Video Type', _ogpData!.videoType),
        _buildCard(context, 'Audio', _ogpData!.audio),
        _buildCard(context, 'Audio (Secure URL)', _ogpData!.audioSecureUrl),
        _buildCard(context, 'Audio Title', _ogpData!.audioTitle),
        _buildCard(context, 'Audio Artist', _ogpData!.audioArtist),
        _buildCard(context, 'Audio Album', _ogpData!.audioAlbum),
        _buildCard(context, 'Audio Type', _ogpData!.audioType),
        _buildCard(
          context,
          'Facebook Administrators',
          _ogpData!.fbAdmins is List<String>
              ? (_ogpData!.fbAdmins as List<String>).join(', ')
              : _ogpData!.fbAdmins,
        ),
        _buildCard(context, 'Facebook App ID', _ogpData!.fbAppId),
        _buildCard(context, 'Twitter Card', _ogpData!.twitterCard),
        _buildCard(context, 'Twitter Site', _ogpData!.twitterSite),
      ],
    );
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
            _form(context),
            const SizedBox(height: 16.0),
            if (_isRetrieving)
              const Center(child: CircularProgressIndicator())
            else if (_ogpData != null)
              _resultColumn(context),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hostEditingController.dispose();

    super.dispose();
  }
}

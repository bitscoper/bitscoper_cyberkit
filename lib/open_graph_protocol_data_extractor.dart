/* By Abdullah As-Sadeed */

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ogp_data_extract/ogp_data_extract.dart';

import 'package:bitscoper_cyber_toolbox/copy_to_clipboard.dart';

class OGPDataExtractorPage extends StatelessWidget {
  const OGPDataExtractorPage({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.open_graph_protocol_data_extractor,
        ),
        centerTitle: true,
        elevation: 4.0,
      ),
      body: const OGPDataExtractorBody(),
    );
  }
}

class OGPDataExtractorBody extends StatefulWidget {
  const OGPDataExtractorBody({super.key});

  @override
  OGPDataExtractorBodyState createState() => OGPDataExtractorBodyState();
}

class OGPDataExtractorBodyState extends State<OGPDataExtractorBody> {
  final _formKey = GlobalKey<FormState>();

  late String _host;
  bool _isRetrieving = false;
  OgpData? _ogpData;

  void _retrieveOGPData() async {
    setState(
      () {
        _isRetrieving = true;
        _ogpData = null;
      },
    );

    try {
      final fetchedOgpData = await OgpDataExtract.execute(_host);

      setState(
        () {
          _ogpData = fetchedOgpData;
          _isRetrieving = false;
        },
      );
    } catch (error) {
      setState(
        () {
          _ogpData = null;
          _isRetrieving = false;
        },
      );

      rethrow;
    }
  }

  Widget _buildCard(
    String title,
    String? value,
  ) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(
          value ?? 'N/A',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.copy_rounded),
          onPressed: () {
            copyToClipBoard(
              context,
              title,
              value ?? 'N/A',
            );
          },
        ),
      ),
    );
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
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText:
                        AppLocalizations.of(context)!.a_host_or_ip_address,
                    hintText: 'https://bitscoper.dev/',
                  ),
                  showCursor: true,
                  maxLines: 1,
                  validator: (
                    String? value,
                  ) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!
                          .enter_a_host_or_ip_address;
                    }

                    return null;
                  },
                  onChanged: (
                    String value,
                  ) {
                    _host = value.trim();
                  },
                  onFieldSubmitted: (
                    String value,
                  ) {
                    if (_formKey.currentState!.validate()) {
                      _retrieveOGPData();
                    }
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: _isRetrieving
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              _retrieveOGPData();
                            }
                          },
                    child: Text(
                      AppLocalizations.of(context)!.extract,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          if (_isRetrieving)
            const Center(
              child: CircularProgressIndicator(),
            )
          else
            _ogpData != null
                ? Column(
                    children: <Widget>[
                      _buildCard(
                        'URL',
                        _ogpData!.url,
                      ),
                      _buildCard(
                        'Type',
                        _ogpData!.type,
                      ),
                      _buildCard(
                        'Title',
                        _ogpData!.title,
                      ),
                      _buildCard(
                        'Description',
                        _ogpData!.description,
                      ),
                      _buildCard(
                        'Image',
                        _ogpData!.image,
                      ),
                      _buildCard(
                        'Image (Secure URL)',
                        _ogpData!.imageSecureUrl,
                      ),
                      _buildCard(
                        'Image Type',
                        _ogpData!.imageType,
                      ),
                      _buildCard(
                        'Image Width',
                        _ogpData!.imageWidth?.toString(),
                      ),
                      _buildCard(
                        'Image Height',
                        _ogpData!.imageHeight?.toString(),
                      ),
                      _buildCard(
                        'Image Alt',
                        _ogpData!.imageAlt,
                      ),
                      _buildCard(
                        'Site Name',
                        _ogpData!.siteName,
                      ),
                      _buildCard(
                        'Determiner',
                        _ogpData!.determiner,
                      ),
                      _buildCard(
                        'Locale',
                        _ogpData!.locale,
                      ),
                      _buildCard(
                        'Locale (Alternate)',
                        _ogpData!.localeAlternate,
                      ),
                      _buildCard(
                        'Latitude',
                        _ogpData!.latitude?.toString(),
                      ),
                      _buildCard(
                        'Longitude',
                        _ogpData!.longitude?.toString(),
                      ),
                      _buildCard(
                        'Street Address',
                        _ogpData!.streetAddress,
                      ),
                      _buildCard(
                        'Locality',
                        _ogpData!.locality,
                      ),
                      _buildCard(
                        'Region',
                        _ogpData!.region,
                      ),
                      _buildCard(
                        'Postal Code',
                        _ogpData!.postalCode,
                      ),
                      _buildCard(
                        'Country Name',
                        _ogpData!.countryName,
                      ),
                      _buildCard(
                        'Email Address',
                        _ogpData!.email,
                      ),
                      _buildCard(
                        'Phone Number',
                        _ogpData!.phoneNumber,
                      ),
                      _buildCard(
                        'Fax Number',
                        _ogpData!.faxNumber,
                      ),
                      _buildCard(
                        'Video',
                        _ogpData!.video,
                      ),
                      _buildCard(
                        'Video (Secure URL)',
                        _ogpData!.videoSecureUrl,
                      ),
                      _buildCard(
                        'Video Height',
                        _ogpData!.videoHeight?.toString(),
                      ),
                      _buildCard(
                        'Video Width',
                        _ogpData!.videoWidth?.toString(),
                      ),
                      _buildCard(
                        'Video Type',
                        _ogpData!.videoType,
                      ),
                      _buildCard(
                        'Audio',
                        _ogpData!.audio,
                      ),
                      _buildCard(
                        'Audio (Secure URL)',
                        _ogpData!.audioSecureUrl,
                      ),
                      _buildCard(
                        'Audio Title',
                        _ogpData!.audioTitle,
                      ),
                      _buildCard(
                        'Audio Artist',
                        _ogpData!.audioArtist,
                      ),
                      _buildCard(
                        'Audio Album',
                        _ogpData!.audioAlbum,
                      ),
                      _buildCard(
                        'Audio Type',
                        _ogpData!.audioType,
                      ),
                      _buildCard(
                        'Facebook Admins',
                        _ogpData!.fbAdmins is List<String>
                            ? (_ogpData!.fbAdmins as List<String>).join(', ')
                            : _ogpData!.fbAdmins,
                      ),
                      _buildCard(
                        'Facebook App ID',
                        _ogpData!.fbAppId,
                      ),
                      _buildCard(
                        'Twitter Card',
                        _ogpData!.twitterCard,
                      ),
                      _buildCard(
                        'Twitter Site',
                        _ogpData!.twitterSite,
                      ),
                    ],
                  )
                : Container(),
        ],
      ),
    );
  }
}

// TODO: Add Bulk Save Button

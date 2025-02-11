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
  late String host;

  bool isRetrieving = false;
  OgpData? ogpData;

  void retrieveOGPData() async {
    setState(
      () {
        isRetrieving = true;
        ogpData = null;
      },
    );

    try {
      final fetchedOgpData = await OgpDataExtract.execute(host);
      setState(
        () {
          ogpData = fetchedOgpData;
          isRetrieving = false;
        },
      );
    } catch (error) {
      setState(
        () {
          ogpData = null;
          isRetrieving = false;
        },
      );
    }
  }

  Widget buildCard(String title, String? value) {
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText:
                        AppLocalizations.of(context)!.a_host_or_ip_address,
                    hintText: 'bitscoper.dev',
                  ),
                  maxLines: 1,
                  showCursor: true,
                  onChanged: (value) {
                    host = value.trim();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a host or IP address!';
                    }
                    return null;
                  },
                  onFieldSubmitted: (value) {
                    if (_formKey.currentState!.validate()) {
                      retrieveOGPData();
                    }
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: isRetrieving
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              retrieveOGPData();
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
          isRetrieving
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ogpData != null
                  ? Column(
                      children: [
                        buildCard(
                          'URL',
                          ogpData!.url,
                        ),
                        buildCard(
                          'Type',
                          ogpData!.type,
                        ),
                        buildCard(
                          'Title',
                          ogpData!.title,
                        ),
                        buildCard(
                          'Description',
                          ogpData!.description,
                        ),
                        buildCard(
                          'Image',
                          ogpData!.image,
                        ),
                        buildCard(
                          'Image (Secure URL)',
                          ogpData!.imageSecureUrl,
                        ),
                        buildCard(
                          'Image Type',
                          ogpData!.imageType,
                        ),
                        buildCard(
                          'Image Width',
                          ogpData!.imageWidth?.toString(),
                        ),
                        buildCard(
                          'Image Height',
                          ogpData!.imageHeight?.toString(),
                        ),
                        buildCard(
                          'Image Alt',
                          ogpData!.imageAlt,
                        ),
                        buildCard(
                          'Site Name',
                          ogpData!.siteName,
                        ),
                        buildCard(
                          'Determiner',
                          ogpData!.determiner,
                        ),
                        buildCard(
                          'Locale',
                          ogpData!.locale,
                        ),
                        buildCard(
                          'Locale (Alternate)',
                          ogpData!.localeAlternate,
                        ),
                        buildCard(
                          'Latitude',
                          ogpData!.latitude?.toString(),
                        ),
                        buildCard(
                          'Longitude',
                          ogpData!.longitude?.toString(),
                        ),
                        buildCard(
                          'Street Address',
                          ogpData!.streetAddress,
                        ),
                        buildCard(
                          'Locality',
                          ogpData!.locality,
                        ),
                        buildCard(
                          'Region',
                          ogpData!.region,
                        ),
                        buildCard(
                          'Postal Code',
                          ogpData!.postalCode,
                        ),
                        buildCard(
                          'Country Name',
                          ogpData!.countryName,
                        ),
                        buildCard(
                          'Email Address',
                          ogpData!.email,
                        ),
                        buildCard(
                          'Phone Number',
                          ogpData!.phoneNumber,
                        ),
                        buildCard(
                          'Fax Number',
                          ogpData!.faxNumber,
                        ),
                        buildCard(
                          'Video',
                          ogpData!.video,
                        ),
                        buildCard(
                          'Video (Secure URL)',
                          ogpData!.videoSecureUrl,
                        ),
                        buildCard(
                          'Video Height',
                          ogpData!.videoHeight?.toString(),
                        ),
                        buildCard(
                          'Video Width',
                          ogpData!.videoWidth?.toString(),
                        ),
                        buildCard(
                          'Video Type',
                          ogpData!.videoType,
                        ),
                        buildCard(
                          'Audio',
                          ogpData!.audio,
                        ),
                        buildCard(
                          'Audio (Secure URL)',
                          ogpData!.audioSecureUrl,
                        ),
                        buildCard(
                          'Audio Title',
                          ogpData!.audioTitle,
                        ),
                        buildCard(
                          'Audio Artist',
                          ogpData!.audioArtist,
                        ),
                        buildCard(
                          'Audio Album',
                          ogpData!.audioAlbum,
                        ),
                        buildCard(
                          'Audio Type',
                          ogpData!.audioType,
                        ),
                        buildCard(
                          'Facebook Admins',
                          ogpData!.fbAdmins is List<String>
                              ? (ogpData!.fbAdmins as List<String>).join(', ')
                              : ogpData!.fbAdmins,
                        ),
                        buildCard(
                          'Facebook App ID',
                          ogpData!.fbAppId,
                        ),
                        buildCard(
                          'Twitter Card',
                          ogpData!.twitterCard,
                        ),
                        buildCard(
                          'Twitter Site',
                          ogpData!.twitterSite,
                        ),
                      ],
                    )
                  : Container(),
        ],
      ),
    );
  }
}

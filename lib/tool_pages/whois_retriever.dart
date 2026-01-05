/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyberkit/commons/application_toolbar.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/commons/notification_sender.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:flutter/material.dart';
import 'package:whois/whois.dart';

class WHOISRetrieverPage extends StatefulWidget {
  const WHOISRetrieverPage({super.key});

  @override
  WHOISRetrieverPageState createState() => WHOISRetrieverPageState();
}

class WHOISRetrieverPageState extends State<WHOISRetrieverPage> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _domainNameEditingController =
      TextEditingController();

  bool _isRetrieving = false;
  late Map<String, String> _whoisInformation = {};

  void _retrieveWHOIS() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _isRetrieving = true;

          _whoisInformation.clear();
        });

        final String response = await Whois.lookup(
          _domainNameEditingController.text.trim(),
          const LookupOptions(port: 43),
        );
        final Map<String, dynamic> parsedResponse = Whois.formatLookup(
          response,
        );

        setState(() {
          _whoisInformation = Map<String, String>.from(parsedResponse);
        });

        await sendNotification(
          title: AppLocalizations.of(
            navigatorKey.currentContext!,
          )!.whois_retriever,
          subtitle: AppLocalizations.of(
            navigatorKey.currentContext!,
          )!.bitscoper_cyberkit,
          body: AppLocalizations.of(navigatorKey.currentContext!)!.retrieved,
          payload: "WHOIS_Retriever",
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

  @override
  void dispose() {
    _domainNameEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(context)!.whois_retriever,
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
                    controller: _domainNameEditingController,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)!.a_domain_name,
                      hintText: 'bitscoper.dev',
                    ),
                    showCursor: true,
                    maxLines: 1,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(
                          context,
                        )!.enter_a_domain_name;
                      }

                      return null;
                    },
                    onChanged: (String value) {},
                    onFieldSubmitted: (String value) {
                      _retrieveWHOIS();
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: _isRetrieving
                          ? null
                          : () {
                              _retrieveWHOIS();
                            },
                      child: Text(AppLocalizations.of(context)!.retrieve),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            if (_isRetrieving)
              const Center(child: CircularProgressIndicator())
            else
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _whoisInformation.entries.map((
                    MapEntry<String, String> entry,
                  ) {
                    return ListTile(
                      title: Text(entry.key),
                      subtitle: Text(entry.value),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

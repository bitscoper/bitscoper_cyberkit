/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyber_toolbox/application_toolbar.dart';
import 'package:bitscoper_cyber_toolbox/main.dart';
import 'package:bitscoper_cyber_toolbox/message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:whois/whois.dart';

class WHOISRetrieverPage extends StatelessWidget {
  const WHOISRetrieverPage({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(context)!.whois_retriever,
      ),
      body: const WHOISRetrieverBody(),
    );
  }
}

class WHOISRetrieverBody extends StatefulWidget {
  const WHOISRetrieverBody({super.key});

  @override
  WHOISRetrieverBodyState createState() => WHOISRetrieverBodyState();
}

class WHOISRetrieverBodyState extends State<WHOISRetrieverBody> {
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
        setState(
          () {
            _isRetrieving = true;

            _whoisInformation.clear();
          },
        );

        final String response = await Whois.lookup(
          _domainNameEditingController.text.trim(),
          const LookupOptions(
            port: 43,
          ),
        );
        final Map<String, dynamic> parsedResponse =
            Whois.formatLookup(response);

        setState(
          () {
            _whoisInformation = Map<String, String>.from(parsedResponse);
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
            _isRetrieving = false;
          },
        );
      }
    }
  }

  @override
  void dispose() {
    _domainNameEditingController.dispose();

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
          Form(
            key: _formKey,
            child: Column(
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
                  validator: (
                    String? value,
                  ) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.enter_a_domain_name;
                    }

                    return null;
                  },
                  onChanged: (
                    String value,
                  ) {},
                  onFieldSubmitted: (
                    String value,
                  ) {
                    _retrieveWHOIS();
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
                            _retrieveWHOIS();
                          },
                    child: Text(
                      AppLocalizations.of(context)!.retrieve,
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
            Card(
              child: Column(
                children: _whoisInformation.entries.map(
                  (
                    MapEntry<String, String> entry,
                  ) {
                    return ListTile(
                      title: Text(entry.key),
                      subtitle: Text(entry.value),
                    );
                  },
                ).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

// TODO: Add Bulk Save Button

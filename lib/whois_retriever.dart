/* By Abdullah As-Sadeed */

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
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.whois_retriever,
        ),
        centerTitle: true,
        elevation: 4.0,
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
  final _formKey = GlobalKey<FormState>();

  late String _domainName;
  bool _isRetrieving = false;
  late Map<String, String> _whoisInformation = {};

  void _retrieveWHOIS() async {
    setState(
      () {
        _isRetrieving = true;
        _whoisInformation.clear();
      },
    );

    try {
      final whoisResponse = await Whois.lookup(
        _domainName,
        const LookupOptions(
          port: 43,
        ),
      );
      final parsedResponse = Whois.formatLookup(whoisResponse);

      setState(
        () {
          _whoisInformation = Map<String, String>.from(parsedResponse);

          _isRetrieving = false;
        },
      );
    } catch (error) {
      setState(
        () {
          _whoisInformation = {
            'Error': error.toString(),
          };

          _isRetrieving = false;
        },
      );
    }
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
                  ) {
                    _domainName = value.trim();
                  },
                  onFieldSubmitted: (
                    String value,
                  ) {
                    if (_formKey.currentState!.validate()) {
                      _retrieveWHOIS();
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
                              _retrieveWHOIS();
                            }
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
                  (entry) {
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

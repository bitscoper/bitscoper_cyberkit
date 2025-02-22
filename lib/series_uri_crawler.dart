/* By Abdullah As-Sadeed */

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

import 'package:bitscoper_cyber_toolbox/copy_to_clipboard.dart';

class SeriesURICrawlerPage extends StatelessWidget {
  const SeriesURICrawlerPage({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.series_uri_crawler,
        ),
        centerTitle: true,
      ),
      body: const SeriesURICrawlerBody(),
    );
  }
}

class SeriesURICrawlerBody extends StatefulWidget {
  const SeriesURICrawlerBody({super.key});

  @override
  SeriesURICrawlerBodyState createState() => SeriesURICrawlerBodyState();
}

class SeriesURICrawlerBodyState extends State<SeriesURICrawlerBody> {
  final _formKey = GlobalKey<FormState>();

  late String uriPrefix, uriSuffix;
  late int lowerLimit = 1, upperLimit = 100;

  bool isCrawling = false;
  Map<String, String> webPages = {};

  Future<void> crawl() async {
    setState(
      () {
        isCrawling = true;
        webPages.clear();
      },
    );

    for (var i = lowerLimit; i <= upperLimit; i++) {
      if (!isCrawling) {
        return;
      }

      var uri = '$uriPrefix$i$uriSuffix';
      var response = await http.get(
        Uri.parse(uri),
      );
      dom.Document document = parser.parse(response.body);

      dom.Element? titleElement = document.querySelector('title');
      String title = titleElement != null ? titleElement.text : 'NO TITLE';

      setState(
        () {
          webPages[uri] = title;
        },
      );
    }

    setState(
      () {
        isCrawling = false;
      },
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
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        keyboardType: TextInputType.url,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.uri_prefix,
                          hintText: 'https://dlhd.sx/stream/stream-',
                        ),
                        showCursor: true,
                        maxLines: 1,
                        validator: (
                          String? value,
                        ) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .enter_a_uri_prefix;
                          }

                          return null;
                        },
                        onChanged: (
                          String value,
                        ) {
                          uriPrefix = value.trim();
                        },
                        onFieldSubmitted: (
                          String value,
                        ) {
                          if (_formKey.currentState!.validate()) {
                            crawl();
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.uri_suffix,
                          hintText: '.php',
                        ),
                        showCursor: true,
                        maxLines: 1,
                        // validator: (
                        //   String? value,
                        // ) {},
                        onChanged: (
                          String value,
                        ) {
                          uriSuffix = value.trim();
                        },
                        onFieldSubmitted: (
                          String value,
                        ) {
                          if (_formKey.currentState!.validate()) {
                            crawl();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.lower_limit,
                          hintText: '1',
                        ),
                        showCursor: true,
                        maxLines: 1,
                        validator: (
                          String? value,
                        ) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .enter_a_lower_limit;
                          } else if (int.tryParse(value) == null) {
                            return AppLocalizations.of(context)!
                                .enter_an_integer;
                          } else if (int.tryParse(value)! < 1) {
                            return AppLocalizations.of(context)!
                                .enter_a_positive_integer;
                          } else if (int.tryParse(value)! > upperLimit) {
                            return AppLocalizations.of(context)!
                                .upper_limit_must_be_greater_than_lower_limit;
                          }

                          return null;
                        },
                        onChanged: (
                          String value,
                        ) {
                          var parsedValue = int.tryParse(
                            value.trim(),
                          );

                          if (parsedValue != null) {
                            upperLimit = parsedValue;
                          }
                        },
                        onFieldSubmitted: (
                          String value,
                        ) {
                          if (_formKey.currentState!.validate()) {
                            crawl();
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.upper_limit,
                          hintText: '100',
                        ),
                        showCursor: true,
                        maxLines: 1,
                        validator: (
                          String? value,
                        ) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .enter_an_upper_limit;
                          } else if (int.tryParse(value) == null) {
                            return AppLocalizations.of(context)!
                                .enter_an_integer;
                          } else if (int.tryParse(value)! < 1) {
                            return AppLocalizations.of(context)!
                                .enter_a_positive_integer;
                          } else if (int.tryParse(value)! < lowerLimit) {
                            return AppLocalizations.of(context)!
                                .upper_limit_must_be_greater_than_lower_limit;
                          }

                          return null;
                        },
                        onChanged: (
                          String value,
                        ) {
                          var parsedValue = int.tryParse(
                            value.trim(),
                          );

                          if (parsedValue != null) {
                            upperLimit = parsedValue;
                          }
                        },
                        onFieldSubmitted: (
                          String value,
                        ) {
                          if (_formKey.currentState!.validate()) {
                            crawl();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: isCrawling
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                crawl();
                              }
                            },
                      child: Text(
                        AppLocalizations.of(context)!.crawl,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: isCrawling
                          ? () {
                              setState(
                                () {
                                  isCrawling = false;
                                },
                              );
                            }
                          : null,
                      child: Text(
                        AppLocalizations.of(context)!.stop,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Column(
            children: <Widget>[
              for (var entry in webPages.entries)
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8,
                  ),
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.link_rounded),
                      title: Text(
                        entry.value,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.copy_rounded),
                        onPressed: () {
                          copyToClipBoard(
                            context,
                            AppLocalizations.of(context)!.uri,
                            entry.key,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              if (isCrawling) ...[
                const SizedBox(
                  height: 8,
                ),
                const Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ],
          )
        ],
      ),
    );
  }
}

// TODO: Add Bulk Save Button

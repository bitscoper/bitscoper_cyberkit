/* By Abdullah As-Sadeed */

import 'package:flutter/material.dart';
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
        title: const Text('Series URI Crawler'),
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
                        decoration: const InputDecoration(
                          labelText: 'URI Prefix',
                          hintText: 'https://dlhd.sx/stream/stream-',
                        ),
                        maxLines: 1,
                        showCursor: true,
                        onChanged: (value) {
                          uriPrefix = value.trim();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a URI prefix!';
                          }

                          return null;
                        },
                        onFieldSubmitted: (value) {
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
                        decoration: const InputDecoration(
                          labelText: 'URI Suffix',
                          hintText: '.php',
                        ),
                        maxLines: 1,
                        showCursor: true,
                        onChanged: (value) {
                          uriSuffix = value.trim();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a URI suffix!';
                          }

                          return null;
                        },
                        onFieldSubmitted: (value) {
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
                        decoration: const InputDecoration(
                          labelText: 'Lower Limit',
                          hintText: '1',
                        ),
                        maxLines: 1,
                        showCursor: true,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          var parsedValue = int.tryParse(value);

                          if (parsedValue != null) {
                            upperLimit = parsedValue;
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a lower limit!';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter an integer!';
                          } else if (int.tryParse(value)! < 1) {
                            return 'Please enter a positive integer!';
                          } else if (int.tryParse(value)! > upperLimit) {
                            return 'Lower limit must be less than upper limit!';
                          }

                          return null;
                        },
                        onFieldSubmitted: (value) {
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
                        decoration: const InputDecoration(
                          labelText: 'Upper Limit',
                          hintText: '100',
                        ),
                        maxLines: 1,
                        showCursor: true,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          var parsedValue = int.tryParse(value);

                          if (parsedValue != null) {
                            upperLimit = parsedValue;
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an upper limit!';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter an integer!';
                          } else if (int.tryParse(value)! < 1) {
                            return 'Please enter a positive integer!';
                          } else if (int.tryParse(value)! < lowerLimit) {
                            return 'Upper limit must be greater than lower limit!';
                          }

                          return null;
                        },
                        onFieldSubmitted: (value) {
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
                      child: const Text('Crawl'),
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
                      child: const Text('Stop'),
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
                            'URI',
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

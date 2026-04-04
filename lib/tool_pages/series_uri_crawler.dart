/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyberkit/commons/application_toolbar.dart';
import 'package:bitscoper_cyberkit/commons/copy_to_clipboard.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/commons/notification_sender.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class SeriesURICrawlerPage extends StatefulWidget {
  const SeriesURICrawlerPage({super.key});

  @override
  SeriesURICrawlerPageState createState() {
    return SeriesURICrawlerPageState();
  }
}

class SeriesURICrawlerPageState extends State<SeriesURICrawlerPage> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _uriPrefixEditingController =
      TextEditingController();
  final TextEditingController _uriSuffixEditingController =
      TextEditingController();
  final TextEditingController _lowerLimitEditingController =
      TextEditingController();
  final TextEditingController _upperLimitEditingController =
      TextEditingController();

  bool _isCrawling = false;
  Map<String, String> webPages = {};

  String? _uriPrefixFieldValidator(BuildContext context, String? value) {
    if ((value == null) || value.isEmpty) {
      return AppLocalizations.of(context)!.enter_a_uri_prefix;
    } else {
      return null;
    }
  }

  String? _lowerLimitFieldValidator(BuildContext context, String? value) {
    if ((value == null) || value.isEmpty) {
      return AppLocalizations.of(context)!.enter_a_lower_limit;
    } else if (int.tryParse(value) == null) {
      return AppLocalizations.of(context)!.enter_an_integer;
    } else if (int.tryParse(value)! < 1) {
      return AppLocalizations.of(context)!.enter_a_positive_integer;
    } else if (int.tryParse(value)! >
        int.tryParse(_upperLimitEditingController.text.trim())!) {
      return AppLocalizations.of(
        context,
      )!.upper_limit_must_be_greater_than_lower_limit;
    } else {
      return null;
    }
  }

  String? _upperLimitFieldValidator(BuildContext context, String? value) {
    if ((value == null) || value.isEmpty) {
      return AppLocalizations.of(context)!.enter_an_upper_limit;
    } else if (int.tryParse(value) == null) {
      return AppLocalizations.of(context)!.enter_an_integer;
    } else if (int.tryParse(value)! < 1) {
      return AppLocalizations.of(context)!.enter_a_positive_integer;
    } else if (int.tryParse(value)! <
        int.tryParse(_lowerLimitEditingController.text.trim())!) {
      return AppLocalizations.of(
        context,
      )!.upper_limit_must_be_greater_than_lower_limit;
    } else {
      return null;
    }
  }

  Future<void> _crawl() async {
    try {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isCrawling = true;
          webPages.clear();
        });

        for (
          int iteration = int.tryParse(
            _lowerLimitEditingController.text.trim(),
          )!;
          iteration <= int.tryParse(_upperLimitEditingController.text.trim())!;
          iteration++
        ) {
          if (!_isCrawling) {
            return;
          }

          String uri =
              '${_uriPrefixEditingController.text.trim()}$iteration${_uriSuffixEditingController.text.trim()}';

          Response response = await http.get(Uri.parse(uri));

          if (response.statusCode == 200) {
            dom.Document document = parser.parse(response.body);

            dom.Element? titleElement = document.querySelector('title');
            String title;
            if (titleElement != null) {
              title = titleElement.text;
            } else {
              title = 'NO TITLE';
            }

            setState(() {
              webPages[uri] = title;
            });
          }
        }

        await sendNotification(
          title: AppLocalizations.of(
            navigatorKey.currentContext!,
          )!.series_uri_crawler,
          subtitle: AppLocalizations.of(
            navigatorKey.currentContext!,
          )!.bitscoper_cyberkit,
          body: AppLocalizations.of(navigatorKey.currentContext!)!.crawled,
          payload: "Series_URI_Crawler",
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
        _isCrawling = false;
      });
    }
  }

  void _stop(BuildContext context) {
    try {
      setState(() {
        _isCrawling = false;
      });
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(
        context,
        AppLocalizations.of(context)!.error,
        error.toString(),
      );
    } finally {}
  }

  Widget _form(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _uriPrefixEditingController,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.uri_prefix,
                    hintText: 'https://bitscoper.dev/publication-',
                  ),
                  showCursor: true,
                  maxLines: 1,
                  validator: (String? value) {
                    return _uriPrefixFieldValidator(context, value);
                  },
                  onChanged: (String value) {},
                  onFieldSubmitted: (String value) {
                    _crawl();
                  },
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                flex: 1,
                child: TextFormField(
                  controller: _uriSuffixEditingController,
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
                  onChanged: (String value) {},
                  onFieldSubmitted: (String value) {
                    _crawl();
                  },
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: _lowerLimitEditingController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.lower_limit,
                    hintText: '1',
                  ),
                  showCursor: true,
                  maxLines: 1,
                  validator: (String? value) {
                    return _lowerLimitFieldValidator(context, value);
                  },
                  onChanged: (String value) {},
                  onFieldSubmitted: (String value) {
                    _crawl();
                  },
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: TextFormField(
                  controller: _upperLimitEditingController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.upper_limit,
                    hintText: '100',
                  ),
                  showCursor: true,
                  maxLines: 1,
                  validator: (String? value) {
                    return _upperLimitFieldValidator(context, value);
                  },
                  onChanged: (String value) {},
                  onFieldSubmitted: (String value) {
                    _crawl();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ElevatedButton(
                onPressed: _isCrawling ? null : _crawl,
                child: Text(AppLocalizations.of(context)!.crawl),
              ),
              ElevatedButton(
                onPressed: _isCrawling
                    ? () {
                        _stop(context);
                      }
                    : null,
                child: Text(AppLocalizations.of(context)!.stop),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _resultColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (MapEntry<String, dynamic> entry in webPages.entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
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
                    try {
                      copyToClipboard(
                        context,
                        AppLocalizations.of(context)!.uri,
                        entry.key,
                      );
                    } catch (error) {
                      debugPrint(error.toString());

                      showMessageDialog(
                        context,
                        AppLocalizations.of(context)!.error,
                        error.toString(),
                      );
                    } finally {}
                  },
                  tooltip: AppLocalizations.of(context)!.copy_to_clipboard,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(context)!.series_uri_crawler,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _form(context),
            const SizedBox(height: 16.0),
            _resultColumn(context),
            const SizedBox(height: 8.0),
            if (_isCrawling) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _uriPrefixEditingController.dispose();
    _uriSuffixEditingController.dispose();
    _lowerLimitEditingController.dispose();
    _upperLimitEditingController.dispose();

    super.dispose();
  }
}

/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyberkit/commons/application_toolbar.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:material_ui/material_ui.dart';
import 'package:whois/whois.dart';

class WHOISRetrieverPage extends StatefulWidget {
  const WHOISRetrieverPage({super.key});

  @override
  WHOISRetrieverPageState createState() {
    return WHOISRetrieverPageState();
  }
}

class WHOISRetrieverPageState extends State<WHOISRetrieverPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _domainNameEditingController =
      TextEditingController();

  bool _isRetrieving = false;
  late Map<String, String> _whoisInformation = {};

  String? _domainNameFieldValidator(BuildContext context, String? value) {
    if ((value == null) || value.isEmpty) {
      return AppLocalizations.of(context)!.enter_a_domain_name;
    } else {
      return null;
    }
  }

  void _retrieve() async {
    try {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isRetrieving = true;

          _whoisInformation.clear();
        });

        final String response = await Whois.lookup(
          _domainNameEditingController.text.trim(),
          const LookupOptions(port: 44),
        );
        final Map<String, dynamic> parsedResponse = Whois.formatLookup(
          response,
        );

        setState(() {
          _whoisInformation = Map<String, String>.from(parsedResponse);
        });
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

  Widget _form(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
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
                    return _domainNameFieldValidator(context, value);
                  },
                  onChanged: (String value) {},
                  onFieldSubmitted: (String value) {
                    _retrieve();
                  },
                  autofocus: true,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: FilledButton.tonal(
                      onPressed: _isRetrieving ? null : _retrieve,
                      child: Text(AppLocalizations.of(context)!.retrieve),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _resultWrapper() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _whoisInformation.entries.map((
          MapEntry<String, String> entry,
        ) {
          return ListTile(title: Text(entry.key), subtitle: Text(entry.value));
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(context)!.whois_retriever,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _form(context),
            _isRetrieving
                ? const Center(child: CircularProgressIndicator())
                : _resultWrapper(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _domainNameEditingController.dispose();

    super.dispose();
  }
}

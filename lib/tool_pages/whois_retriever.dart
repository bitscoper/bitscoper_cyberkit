/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyberkit/commons/application_toolbar.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:whois/whois.dart';

final Provider<TextEditingController> domainNameControllerProvider =
    Provider.autoDispose<TextEditingController>((Ref ref) {
      final TextEditingController controller = TextEditingController();
      ref.onDispose(controller.dispose);

      return controller;
    });

final AsyncNotifierProvider<WhoisNotifier, Map<String, String>>
whoisInformationProvider =
    AsyncNotifierProvider.autoDispose<WhoisNotifier, Map<String, String>>(() {
      return WhoisNotifier();
    });

class WhoisNotifier extends AsyncNotifier<Map<String, String>> {
  @override
  Future<Map<String, String>> build() async {
    return <String, String>{};
  }

  Future<void> retrieve(String domainName) async {
    state = const AsyncValue<Map<String, String>>.loading();

    try {
      final String response = await Whois.lookup(
        domainName,
        const LookupOptions(port: 43),
      );
      final Map<String, dynamic> parsedResponse = Whois.formatLookup(response);

      state = AsyncValue<Map<String, String>>.data(
        Map<String, String>.from(parsedResponse),
      );
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(
        navigatorKey.currentContext!,
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );

      state = AsyncValue<Map<String, String>>.error(error, StackTrace.current);
    } finally {}
  }
}

class WHOISRetrieverPage extends ConsumerStatefulWidget {
  const WHOISRetrieverPage({super.key});

  @override
  ConsumerState<WHOISRetrieverPage> createState() {
    return _WHOISRetrieverPageState();
  }
}

class _WHOISRetrieverPageState extends ConsumerState<WHOISRetrieverPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _domainNameFieldValidator(BuildContext context, String? value) {
    if ((value == null) || value.isEmpty) {
      return AppLocalizations.of(context)!.enter_a_domain_name;
    } else {
      return null;
    }
  }

  void _retrieve() {
    try {
      final TextEditingController controller = ref.read<TextEditingController>(
        domainNameControllerProvider,
      );

      if (_formKey.currentState!.validate()) {
        ref
            .read<WhoisNotifier>(whoisInformationProvider.notifier)
            .retrieve(controller.text.trim());
      }
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(
        navigatorKey.currentContext!,
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );
    } finally {}
  }

  Widget _form(BuildContext context) {
    final TextEditingController controller = ref.watch<TextEditingController>(
      domainNameControllerProvider,
    );

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
                  controller: controller,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.a_domain_name,
                    hintText: 'bitscoper-computer-museum.site',
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
                      onPressed: () {
                        _retrieve();
                      },
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

  Widget _resultWrapper(Map<String, String> whoisInformation) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: whoisInformation.entries.map<ListTile>((
          MapEntry<String, String> entry,
        ) {
          return ListTile(title: Text(entry.key), subtitle: Text(entry.value));
        }).toList(),
      ),
    );
  }

  Widget _progressIndicator() {
    return Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<Map<String, String>> whoisInformationAsync = ref
        .watch<AsyncValue<Map<String, String>>>(whoisInformationProvider);

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
            whoisInformationAsync.when<Widget>(
              data: (Map<String, String> data) {
                if (data.isEmpty) {
                  return const SizedBox.shrink();
                }

                return _resultWrapper(data);
              },
              loading: () {
                return _progressIndicator();
              },
              error: (Object error, StackTrace stackTrace) {
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}

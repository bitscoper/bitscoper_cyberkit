/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:flutter/material.dart';

class _LanguageTile extends StatelessWidget {
  final String name;
  final String code;

  const _LanguageTile({required this.name, required this.code});

  @override
  Widget build(BuildContext context) {
    final bool isCurrentLocale =
        (Localizations.localeOf(context).languageCode == code);

    return ListTile(
      leading: const Icon(Icons.language_rounded),
      title: Text(name),
      trailing: isCurrentLocale ? const Icon(Icons.check_rounded) : null,
      enabled: !isCurrentLocale,
      onTap: () {
        try {
          BitscoperCyberKitState.instance?.changeLocale(Locale(code));
          Navigator.of(context).pop();
        } catch (error) {
          showMessageDialog(
            AppLocalizations.of(context)!.error,
            error.toString(),
          );
        } finally {}
      },
    );
  }
}

class ApplicationToolBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  const ApplicationToolBar({super.key, required this.title});

  void _showLocaleSelector(BuildContext context) {
    try {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
        ),
        builder: (BuildContext context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8.0),
                Center(
                  child: Container(
                    width: 40.0,
                    height: 4.0,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.change_locale,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      _LanguageTile(name: "English", code: "en"),
                      _LanguageTile(name: "বাংলা", code: "bn"),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          );
        },
      );
    } catch (error) {
      showMessageDialog(AppLocalizations.of(context)!.error, error.toString());
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 4.0,
      title: Text(title),
      centerTitle: false,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            (Theme.of(context).brightness == Brightness.dark)
                ? Icons.light_mode_rounded
                : Icons.dark_mode_rounded,
          ),
          tooltip: AppLocalizations.of(context)!.toggle_theme,
          onPressed: () {
            try {
              BitscoperCyberKitState.instance?.toggleTheme();
            } catch (error) {
              showMessageDialog(
                AppLocalizations.of(context)!.error,
                error.toString(),
              );
            } finally {}
          },
        ),
        IconButton(
          icon: const Icon(Icons.language_rounded),
          tooltip: AppLocalizations.of(context)!.change_locale,
          onPressed: () {
            try {
              _showLocaleSelector(context);
            } catch (error) {
              showMessageDialog(
                AppLocalizations.of(context)!.error,
                error.toString(),
              );
            } finally {}
          },
        ),
      ],
      automaticallyImplyActions: true,
      actionsPadding: EdgeInsets.zero,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:flutter/material.dart';

enum _MenuAction { toggleTheme, changeLocale }

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
          debugPrint(error.toString());

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

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 4.0,
      title: Text(title),
      centerTitle: false,
      actions: <Widget>[
        PopupMenuButton<_MenuAction>(
          icon: const Icon(Icons.more_vert_rounded),
          onSelected: (_MenuAction action) {
            try {
              switch (action) {
                case _MenuAction.toggleTheme:
                  BitscoperCyberKitState.instance?.toggleTheme();
                  break;
                case _MenuAction.changeLocale:
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(8.0),
                      ),
                    ),
                    builder: (BuildContext context) {
                      return SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Column(
                                children: <Widget>[
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

                  break;
              }
            } catch (error) {
              debugPrint(error.toString());

              showMessageDialog(
                AppLocalizations.of(context)!.error,
                error.toString(),
              );
            } finally {}
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              value: _MenuAction.toggleTheme,
              child: Row(
                children: <Widget>[
                  Icon(
                    (Theme.of(context).brightness == Brightness.dark)
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                  ),
                  const SizedBox(width: 12),
                  Text(AppLocalizations.of(context)!.toggle_theme),
                ],
              ),
            ),
            PopupMenuItem(
              value: _MenuAction.changeLocale,
              child: Row(
                children: <Widget>[
                  const Icon(Icons.language_rounded),
                  const SizedBox(width: 12),
                  Text(AppLocalizations.of(context)!.change_locale),
                ],
              ),
            ),
          ],
        ),
      ],
      automaticallyImplyActions: true,
      actionsPadding: EdgeInsets.zero,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/* By Abdullah As-Sadeed */

import 'dart:io' show Platform;
import 'package:bitscoper_cyber_toolbox/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  LicenseRegistry.addLicense(
    () async* {
      final license = await rootBundle.loadString('google_fonts/OFL.txt');
      yield LicenseEntryWithLineBreaks(
        ['google_fonts'],
        license,
      );
    },
  );

  runApp(
    const BitscoperCyberToolBox(),
  );
}

class BitscoperCyberToolBox extends StatefulWidget {
  const BitscoperCyberToolBox({super.key});

  @override
  BitscoperCyberToolBoxState createState() => BitscoperCyberToolBoxState();
}

class BitscoperCyberToolBoxState extends State<BitscoperCyberToolBox> {
  ValueNotifier<bool> isDarkTheme = ValueNotifier<bool>(false);
  bool userToggledTheme = false;
  Locale userLocale = const Locale('en');

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid || Platform.isIOS) {
      const QuickActions quickActions = QuickActions();

      quickActions.initialize(
        (shortcutType) {
          if (shortcutType == 'source_code') {
            launchUrl(
              Uri.parse(
                  'https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/'),
            );
          }
        },
      );

      late final String platformIconName;

      if (Platform.isAndroid) {
        platformIconName = 'ic_launcher';
      } else if (Platform.isIOS) {
        platformIconName = 'AppIcon';
      }

      quickActions.setShortcutItems(
        <ShortcutItem>[
          ShortcutItem(
            type: 'source_code',
            localizedTitle: AppLocalizations.of(context)!.source_code,
            icon: platformIconName,
          ),
        ],
      );
    }
  }

  void changeLocale(Locale locale) {
    setState(
      () {
        userLocale = locale;
      },
    );
  }

  void toggleTheme() {
    setState(
      () {
        userToggledTheme = true;
        isDarkTheme.value = !isDarkTheme.value;
      },
    );
  }

  ThemeData buildTheme(
    Brightness brightness,
  ) {
    var baseTheme = ThemeData(
      brightness: brightness,
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.notoSansTextTheme(
        baseTheme.textTheme,
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final brightness = MediaQuery.of(context).platformBrightness;

    if (!userToggledTheme) {
      isDarkTheme.value = brightness == Brightness.dark;
    }

    return ValueListenableBuilder<bool>(
      valueListenable: isDarkTheme,
      builder: (
        context,
        isDark,
        child,
      ) {
        return MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: userLocale,
          theme: buildTheme(
            Brightness.light,
          ),
          darkTheme: buildTheme(
            Brightness.dark,
          ),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: HomePage(
            changeLocale: changeLocale,
            toggleTheme: toggleTheme,
          ),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

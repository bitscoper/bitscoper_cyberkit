/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyber_toolbox/home.dart';
import 'package:bitscoper_cyber_toolbox/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:url_launcher/url_launcher.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');

    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  runApp(const BitscoperCyberToolBox());
}

class BitscoperCyberToolBox extends StatefulWidget {
  const BitscoperCyberToolBox({super.key});

  @override
  BitscoperCyberToolBoxState createState() => BitscoperCyberToolBoxState();
}

class BitscoperCyberToolBoxState extends State<BitscoperCyberToolBox> {
  Locale _userLocale = const Locale('en');

  final ValueNotifier<bool> _isDarkTheme = ValueNotifier<bool>(false);
  bool _userToggledTheme = false;

  @override
  void initState() {
    super.initState();

    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android)) {
      final QuickActions quickActions = QuickActions();

      quickActions.initialize((shortcutType) {
        if (shortcutType == 'source_code') {
          launchUrl(
            Uri.parse('https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/'),
          );
        }
      });

      late final String platformIconName;

      if (defaultTargetPlatform == TargetPlatform.android) {
        platformIconName = 'ic_launcher';
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        platformIconName = 'AppIcon';
      }

      quickActions.setShortcutItems(<ShortcutItem>[
        ShortcutItem(
          type: 'source_code',
          // localizedTitle: AppLocalizations.of(navigatorKey.currentContext!)!.source_code,
          localizedTitle: "Source Code",
          icon: platformIconName,
        ),
      ]);
    }
  }

  void _changeLocale(Locale locale) {
    setState(() {
      _userLocale = locale;
    });
  }

  void _toggleTheme() {
    setState(() {
      _userToggledTheme = true;
      _isDarkTheme.value = !_isDarkTheme.value;
    });
  }

  ThemeData _buildTheme(Brightness brightness) {
    ThemeData baseTheme = ThemeData(brightness: brightness);

    return baseTheme.copyWith(
      textTheme: GoogleFonts.notoSansTextTheme(baseTheme.textTheme),
    );
  }

  @override
  void dispose() {
    _isDarkTheme.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;

    if (!_userToggledTheme) {
      _isDarkTheme.value = brightness == Brightness.dark;
    }

    return ValueListenableBuilder<bool>(
      valueListenable: _isDarkTheme,
      builder: (context, isDark, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: _userLocale,
          theme: _buildTheme(Brightness.light),
          darkTheme: _buildTheme(Brightness.dark),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: HomePage(
            changeLocale: _changeLocale,
            toggleTheme: _toggleTheme,
          ),
          debugShowCheckedModeBanner: false,
          showSemanticsDebugger: false,
        );
      },
    );
  }
}

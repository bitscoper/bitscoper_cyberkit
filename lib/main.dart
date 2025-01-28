/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyber_toolbox/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    const MainApp(),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  ValueNotifier<bool> isDarkTheme = ValueNotifier<bool>(false);
  bool userToggledTheme = false;

  @override
  void initState() {
    super.initState();

    const QuickActions quickActions = QuickActions();
    quickActions.initialize(
      (shortcutType) {
        if (shortcutType == 'source_code') {
          launchUrl(
            Uri.parse('https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/'),
          );
        }
      },
    );
    quickActions.setShortcutItems(
      <ShortcutItem>[
        const ShortcutItem(
            type: 'source_code',
            localizedTitle: 'Source Code',
            icon: 'ic_launcher'), /* Android only */
      ],
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
          theme: _buildTheme(Brightness.light),
          darkTheme: _buildTheme(Brightness.dark),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: HomePage(
            toggleTheme: toggleTheme,
          ),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }

  ThemeData _buildTheme(
    Brightness brightness,
  ) {
    var baseTheme = ThemeData(brightness: brightness);

    return baseTheme.copyWith(
      textTheme: GoogleFonts.notoSansTextTheme(baseTheme.textTheme),
    );
  }
}

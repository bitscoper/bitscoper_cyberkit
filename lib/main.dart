/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/home.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:network_tools_flutter/network_tools_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:url_launcher/url_launcher.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');

    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  WidgetsFlutterBinding.ensureInitialized();

  await configureNetworkToolsFlutter(
    (await getApplicationDocumentsDirectory()).path,
    enableDebugging: kDebugMode,
  );

  runApp(const BitscoperCyberKit());
}

class BitscoperCyberKit extends StatefulWidget {
  const BitscoperCyberKit({super.key});

  @override
  BitscoperCyberKitState createState() => BitscoperCyberKitState();
}

class BitscoperCyberKitState extends State<BitscoperCyberKit> {
  static BitscoperCyberKitState? instance;
  Locale _userLocale = const Locale('en');

  final ValueNotifier<bool> _isDarkTheme = ValueNotifier<bool>(false);
  bool _userToggledTheme = false;

  @override
  void initState() {
    super.initState();
    instance = this;

    if (!kIsWeb &&
        ((defaultTargetPlatform == TargetPlatform.iOS) ||
            (defaultTargetPlatform == TargetPlatform.android))) {
      final QuickActions quickActions = QuickActions();

      quickActions.initialize((shortcutType) {
        if (shortcutType == 'source_code') {
          launchUrl(
            Uri.parse('https://github.com/bitscoper/Bitscoper_CyberKit/'),
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
          localizedTitle: "Source Code",
          /* Application does not open if localized. */
          icon: platformIconName,
        ),
      ]);
    }
  }

  void changeLocale(Locale locale) {
    try {
      setState(() {
        _userLocale = locale;
      });
    } catch (error) {
      showMessageDialog(AppLocalizations.of(context)!.error, error.toString());
    } finally {}
  }

  void toggleTheme() {
    try {
      setState(() {
        _userToggledTheme = true;
        _isDarkTheme.value = !_isDarkTheme.value;
      });
    } catch (error) {
      showMessageDialog(AppLocalizations.of(context)!.error, error.toString());
    } finally {}
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

    instance = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_userToggledTheme) {
      _isDarkTheme.value =
          (MediaQuery.of(context).platformBrightness == Brightness.dark);
    }

    return ValueListenableBuilder<bool>(
      valueListenable: _isDarkTheme,
      builder: (BuildContext context, bool isDark, Widget? child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: _userLocale,
          theme: _buildTheme(Brightness.light),
          darkTheme: _buildTheme(Brightness.dark),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: HomePage(),
          debugShowCheckedModeBanner: false,
          showSemanticsDebugger: false,
        );
      },
    );
  }
}

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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  await configureNetworkToolsFlutter(
    (await getApplicationSupportDirectory()).path,
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

  static const String _localePreferenceKey = 'user_preferred_locale';
  static const String _themePreferenceKey = 'user_preferred_theme';

  Locale _locale = const Locale('en');
  final ValueNotifier<bool> _isDarkTheme = ValueNotifier<bool>(true);

  bool _isUserPreferencesLoaded = false;

  @override
  void initState() {
    super.initState();
    instance = this;

    _initializeUserPreferences();
    _initializeQuickActions();
  }

  Future<void> _initializeUserPreferences() async {
    try {
      final SharedPreferences userPreferences =
          await SharedPreferences.getInstance();

      final String? userPreferredLocale = userPreferences.getString(
        _localePreferenceKey,
      );
      final bool? doesUserPrefersDarkTheme = userPreferences.getBool(
        _themePreferenceKey,
      );

      if (userPreferredLocale != null) {
        _locale = Locale(userPreferredLocale);
      } else {
        final Locale deviceLocale =
            WidgetsBinding.instance.platformDispatcher.locale;

        final Iterable<String> supportedLocales = AppLocalizations
            .supportedLocales
            .map((Locale locale) => locale.languageCode);

        if (supportedLocales.contains(deviceLocale.languageCode)) {
          _locale = Locale(deviceLocale.languageCode);
        } else {
          _locale = const Locale('en');
        }
      }

      if (doesUserPrefersDarkTheme != null) {
        _isDarkTheme.value = doesUserPrefersDarkTheme;
      } else {
        final Brightness deviceBrightness =
            WidgetsBinding.instance.platformDispatcher.platformBrightness;

        _isDarkTheme.value = deviceBrightness == Brightness.dark;

        if (deviceBrightness != Brightness.light &&
            deviceBrightness != Brightness.dark) {
          _isDarkTheme.value = true;
        }
      }

      setState(() {
        _isUserPreferencesLoaded = true;
      });
    } catch (error) {
      showMessageDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );
    } finally {}
  }

  void _initializeQuickActions() {
    try {
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
    } catch (error) {
      showMessageDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );
    } finally {}
  }

  Future<void> changeLocale(Locale locale) async {
    try {
      final SharedPreferences userPreferences =
          await SharedPreferences.getInstance();

      await userPreferences.remove(_localePreferenceKey);
      await userPreferences.setString(
        _localePreferenceKey,
        locale.languageCode,
      );

      setState(() {
        _locale = locale;
      });

      WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(
                navigatorKey.currentContext!,
              )!.your_preference_has_been_saved,
            ),
          ),
        );
      }, debugLabel: "SnackBar after Preferring Locale");
    } catch (error) {
      showMessageDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );
    } finally {}
  }

  Future<void> toggleTheme() async {
    try {
      final SharedPreferences userPreferences =
          await SharedPreferences.getInstance();
      _isDarkTheme.value = !_isDarkTheme.value;

      await userPreferences.remove(_themePreferenceKey);
      await userPreferences.setBool(_themePreferenceKey, _isDarkTheme.value);

      setState(() {});

      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(
              navigatorKey.currentContext!,
            )!.your_preference_has_been_saved,
          ),
        ),
      );
    } catch (error) {
      showMessageDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );
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
    if (!_isUserPreferencesLoaded) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
        debugShowCheckedModeBanner: false,
        showSemanticsDebugger: false,
      );
    } else {
      return ValueListenableBuilder<bool>(
        valueListenable: _isDarkTheme,
        builder: (BuildContext context, bool isDark, Widget? child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: _locale,
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
}

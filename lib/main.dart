import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:practi_sun/pages/welcome.dart';

import 'theme/palettes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.changeLanguage(newLocale);
  }

  static String getLocalCode(BuildContext context) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    return state!.getLocalCode();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('fr', 'FR');

  void changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  String getLocalCode() {
    return _locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    MaterialColor materialColorPrimary = MaterialColor(0xFF64A369, primary);
    MaterialColor materialColorSecondary = MaterialColor(0xFF8DC9CC, secondary);
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primarySwatch: materialColorPrimary,
        accentColor: materialColorSecondary,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: materialColorPrimary,
        accentColor: materialColorSecondary,
      ),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Adaptive Theme Demo',
        theme: theme,
        darkTheme: darkTheme,
        locale: _locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: WelcomPage(key: UniqueKey(), title: 'Welcome'),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

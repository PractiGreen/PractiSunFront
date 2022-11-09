import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import '../main.dart';

class MyAppBar extends StatefulWidget with PreferredSizeWidget {
  const MyAppBar({super.key, required this.title});

  final String title;

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MyAppBarState extends State<MyAppBar> {
  bool darkmode = false;

  dynamic savedThemeMode;

  @override
  void initState() {
    super.initState();
    getCurrentTheme();
  }

  Future getCurrentTheme() async {
    savedThemeMode = await AdaptiveTheme.getThemeMode();
    if (savedThemeMode.toString() == 'AdaptiveThemeMode.dark') {
      setState(() {
        darkmode = true;
      });
    } else {
      setState(() {
        darkmode = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      actions: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: IconButton(
                icon: Icon(
                    darkmode ? Icons.nightlight_round : Icons.wb_sunny_rounded),
                onPressed: (() {
                  setState(() {
                    darkmode = !darkmode;
                  });
                  if (darkmode == true) {
                    AdaptiveTheme.of(context).setDark();
                  } else {
                    AdaptiveTheme.of(context).setLight();
                  }
                }))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: IconButton(
            icon: Image.asset(MyApp.getLocalCode(context) == "en"
                ? 'assets/icon/flag-en.png'
                : 'assets/icon/flag-fr.png'),
            onPressed: () {
              MyApp.setLocale(
                  context,
                  MyApp.getLocalCode(context) == "en"
                      ? const Locale('fr')
                      : const Locale('en'));
            },
          ),
        ),
      ],
    );
  }
}

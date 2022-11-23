import 'package:flutter/material.dart';
import 'package:practi_sun/layout/appBar.dart';
import 'package:practi_sun/layout/nav_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class WelcomPage extends StatefulWidget {
  const WelcomPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<WelcomPage> createState() => _WelcomPage();
}

class _WelcomPage extends State<WelcomPage> {
  @override
  StatefulWidget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBarr(),
      appBar: MyAppBar(
        title: widget.title,
      ),
      body: ListView(
        children: <Widget>[
          Center(
              child: Column(
            children: [
              Text("Welcome"),
              Text(AppLocalizations.of(context)!.helloWorld),
            ],
          )),
        ],
      ),
    );
  }
}

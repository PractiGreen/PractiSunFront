import 'package:flutter/material.dart';
import 'package:practi_sun/components/loader.dart';
import 'package:practi_sun/layout/appBar.dart';
import 'package:practi_sun/layout/nav_bar.dart';
import 'package:practi_sun/pages/register.dart';
import 'package:practi_sun/pages/welcome.dart';
import 'package:practi_sun/theme/palettes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../components/hover.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  String _username = "";
  String _password = "";
  bool loading = false;

  Future<void> _login() async {
    setState(() {
      loading = true;
    });
    var response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api-token-auth/?format=json'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'username': _username, 'password': _password}));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      // ignore: invalid_use_of_visible_for_testing_member
      SharedPreferences.setMockInitialValues({});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', jsonResponse["token"]);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              WelcomPage(key: UniqueKey(), title: 'Welcome')));
    }
    if (response.statusCode == 400) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          // backgroundColor: const Color(0xFF343442),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          title: Text(AppLocalizations.of(context)!.error,
              style:
                  TextStyle(color: primary[800], fontWeight: FontWeight.bold)),
          content: Text(
            AppLocalizations.of(context)!.errorUsernameOrPassword,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: Text('OK',
                  style: TextStyle(
                      color: primary[800], fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
      setState(() {
        loading = false;
      });
    }

    setState(() {
      loading = false;
    });
    // return Future.error("error");
  }

  @override
  StatefulWidget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBarr(),
      appBar: MyAppBar(
        title: AppLocalizations.of(context)!.login,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: loading
                ? const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Loading ...'),
                    ),
                    Loader(size: 80)
                  ]
                : [
                    Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Image.asset("assets/logo/practigreen_small.png",
                            height: 200)),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 300,
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.email,
                              ),
                              onChanged: (String value) => setState(() {
                                _username = value;
                              }),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 300,
                            child: TextField(
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                  labelText:
                                      AppLocalizations.of(context)!.password),
                              onChanged: (String value) => setState(() {
                                _password = value;
                              }),
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(100, 38)),
                              onPressed: () {
                                _login();
                              },
                              child: Text(AppLocalizations.of(context)!.login),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: HoverBuilder(
                            builder: (isHovered) {
                              return MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => RegisterPage(
                                                key: UniqueKey())));
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.notRegister,
                                    style: TextStyle(
                                      decoration: isHovered
                                          ? TextDecoration.underline
                                          : null,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}

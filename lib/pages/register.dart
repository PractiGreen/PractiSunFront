import 'package:flutter/material.dart';
import 'package:practi_sun/components/hover.dart';
import 'package:practi_sun/components/loader.dart';
import 'package:practi_sun/layout/appBar.dart';
import 'package:practi_sun/layout/nav_bar.dart';
import 'package:practi_sun/pages/login.dart';
import 'package:practi_sun/pages/welcome.dart';
import 'package:practi_sun/theme/palettes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  String _email = "";
  String _firstName = "";
  String _lastName = "";
  String _password = "";
  // String _passwordConfirm = "";
  bool _passwordHidden = true;
  bool loading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _register() async {
    setState(() {
      loading = true;
    });
    var response = await http.post(
        Uri.parse('http://127.0.0.1:8000/create_user/?format=json'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'username': _email,
          'password': _password,
          'last_name': _lastName,
          'first_name': _firstName
        }));
    if (response.statusCode == 200) {
      var response = await http.post(
          Uri.parse('http://127.0.0.1:8000/api-token-auth/?format=json'),
          headers: {"Content-Type": "application/json"},
          body: json.encode({'username': _email, 'password': _password}));
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.mailAlreadyExist,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: HoverBuilder(
                  builder: (isHovered) {
                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  LoginPage(key: UniqueKey())));
                        },
                        child: Text(
                          AppLocalizations.of(context)!.login,
                          style: TextStyle(
                            decoration:
                                isHovered ? TextDecoration.underline : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
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
        title: AppLocalizations.of(context)!.register,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:
                //  loading
                //     ? const [
                //         Padding(
                //           padding: EdgeInsets.all(8.0),
                //           child: Text('Loading ...'),
                //         ),
                //         Loader(size: 80)
                //       ]
                //     :
                [
              Expanded(
                flex: 2,
                child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Image.asset("assets/logo/practigreen_small.png",
                        height: 200)),
              ),
              Expanded(
                flex: 8,
                child: Form(
                  key: _formKey,
                  child: Wrap(
                    direction: Axis.vertical,
                    children: [
                      // * Firstname
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SizedBox(
                          width: 300,
                          child: TextFormField(
                            style: const TextStyle(color: Colors.white70),
                            decoration: InputDecoration(
                              labelText:
                                  AppLocalizations.of(context)!.firstName,
                            ),
                            onChanged: (String value) => setState(() {
                              _firstName = value;
                            }),
                          ),
                        ),
                      ),
                      // * Lastname
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SizedBox(
                          width: 300,
                          child: TextFormField(
                            style: const TextStyle(color: Colors.white70),
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.lastName,
                            ),
                            onChanged: (String value) => setState(() {
                              _lastName = value;
                            }),
                          ),
                        ),
                      ),
                      // * Email
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SizedBox(
                          width: 300,
                          child: TextFormField(
                              style: const TextStyle(color: Colors.white70),
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.email,
                              ),
                              onChanged: (String value) => setState(() {
                                    _email = value;
                                  }),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .fieldErrorEmpty;
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value)) {
                                  return AppLocalizations.of(context)!
                                      .emaildErrorNotValid;
                                }
                                return null;
                              }),
                        ),
                      ),
                      // * Password
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SizedBox(
                          width: 300,
                          child: TextFormField(
                            obscureText: _passwordHidden,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecoration(
                                labelText:
                                    AppLocalizations.of(context)!.password,
                                errorMaxLines: 3,
                                suffixIcon: IconButton(
                                    onPressed: () => {
                                          setState(() => {
                                                _passwordHidden =
                                                    !_passwordHidden
                                              })
                                        },
                                    icon: const Icon(
                                        Icons.remove_red_eye_sharp))),
                            onChanged: (String value) => setState(() {
                              _password = value;
                            }),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .fieldErrorEmpty;
                              }
                              if (!RegExp(
                                      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
                                  .hasMatch(value)) {
                                return AppLocalizations.of(context)!
                                    .passwordErrorRegex;
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      // * Password confirmation
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SizedBox(
                          width: 300,
                          child: TextFormField(
                            obscureText: _passwordHidden,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecoration(
                                errorMaxLines: 3,
                                labelText: AppLocalizations.of(context)!
                                    .passwordConfirmation,
                                suffixIcon: IconButton(
                                    onPressed: () => {
                                          setState(() => {
                                                _passwordHidden =
                                                    !_passwordHidden
                                              })
                                        },
                                    icon: const Icon(
                                        Icons.remove_red_eye_sharp))),
                            // onChanged: (String value) => setState(() {
                            //   _passwordConfirm = value;
                            // }),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .fieldErrorEmpty;
                              }
                              if (value != _password) {
                                return AppLocalizations.of(context)!
                                    .passwordConfirmationErrorNotSame;
                              }
                              return null;
                            },
                          ),
                        ),
                      ),

                      // * Submit
                      SizedBox(
                        width: 300,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: loading
                                    ? Loader(size: 40)
                                    : ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            minimumSize: const Size(100, 38)),
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            // Process data.
                                            _register();
                                          }
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .register),
                                      ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

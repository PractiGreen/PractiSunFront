import 'package:flutter/material.dart';
import 'package:practi_sun/components/loader.dart';
import 'package:practi_sun/pages/login.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:practi_sun/pages/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBarr extends StatelessWidget {
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  const NavBarr({Key? key}) : super(key: key);

  Future<SharedPreferences> _token() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        child: FutureBuilder<SharedPreferences>(
            future: _token(),
            builder: (BuildContext context,
                AsyncSnapshot<SharedPreferences> snapshot) {
              SharedPreferences? prefs = snapshot.data;
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: Loader(size: 40));
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text(
                      '${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    );
                  } else {
                    return ListView(
                      children: <Widget>[
                        if (prefs!.getString('token') != null)
                          Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: buildMenuItem(
                                    text: 'Logout',
                                    icon: Icons.logout_outlined,
                                    onClicked: () => {
                                      prefs.remove('token'),
                                      selectedItem(context, 0)
                                    },
                                  )),
                            ],
                          )
                        else
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: buildMenuItem(
                                    text: AppLocalizations.of(context)!.login,
                                    icon: Icons.login_outlined,
                                    onClicked: () => selectedItem(context, 0)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: buildMenuItem(
                                    text:
                                        AppLocalizations.of(context)!.register,
                                    icon: Icons.account_circle_outlined,
                                    onClicked: () => selectedItem(context, 1)),
                              ),
                            ],
                          ),
                      ],
                    );
                  }
                default:
                  const Text('');
              }

              return ListView(
                children: const <Widget>[],
              );
            }),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ));
        break;
      case 1:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const RegisterPage()));
        break;
    }
  }
}

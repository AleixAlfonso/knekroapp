import 'package:firebase_auth/firebase_auth.dart';
import 'package:knekroapp/pages/config/config.dart';
import 'package:knekroapp/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuracion'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            trailing: Icon(
              Icons.brightness_medium,
              size: mediaQuery.size.height * 0.03,
            ),
            title: Text(
              'Tema Claro/Oscuro',
            ),
            onTap: () async {
              SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();
              setState(() {
                currentTheme.switchTheme();
              });
            },
          ),
          addAudio(mediaQuery),
          isAdmin ? cerrarSesion(mediaQuery) : iniciarSesion(mediaQuery),
          information(mediaQuery),
        ],
      ),
    );
  }

  Widget cerrarSesion(MediaQueryData mediaQuery) {
    return ListTile(
      trailing: Icon(
        Icons.logout,
        size: mediaQuery.size.height * 0.03,
      ),
      title: Text('Cerrar Sesion'),
      onTap: () async {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setBool('isAdmin', false);
        isAdmin = false;
        FirebaseAuth.instance.signOut();
        Navigator.pushAndRemoveUntil<void>(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context) => MainPage()),
          ModalRoute.withName('mainpage'),
        );
      },
    );
  }

  Widget iniciarSesion(MediaQueryData mediaQuery) {
    return ListTile(
      title: Text('Admin Log In'),
      trailing: Icon(
        Icons.login,
        size: mediaQuery.size.height * 0.03,
      ),
      onTap: () {
        Navigator.pushNamed(context, 'adminlogin');
      },
    );
  }

  Widget addAudio(MediaQueryData mediaQuery) {
    if (isAdmin) {
      return ListTile(
        trailing: Icon(
          Icons.add,
          size: mediaQuery.size.height * 0.04,
        ),
        title: Text(
          'Añadir audio',
        ),
        onTap: () {
          Navigator.pushNamed(context, 'addaudio');
        },
      );
    }
    return Container();
  }

  information(MediaQueryData mediaQuery) {
    return ListTile(
      trailing: Icon(
        Icons.info,
        size: mediaQuery.size.height * 0.03,
      ),
      title: Text(
        'Información',
      ),
      onTap: () {
        Navigator.pushNamed(context, 'infopage');
      },
    );
  }
}

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuracion'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Tema Claro/Oscuro'),
            trailing: IconButton(
              icon: Icon(Icons.brightness_medium),
              onPressed: () async {
                SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                setState(() {
                  currentTheme.switchTheme();
                });
              },
            ),
          ),
          addAudio(),
          isAdmin ? cerrarSesion() : iniciarSesion(),
          information(),
        ],
      ),
    );
  }

  Widget cerrarSesion() {
    return ListTile(
      trailing: Icon(Icons.logout),
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

  Widget iniciarSesion() {
    return ListTile(
      title: Text('Admin Log In'),
      trailing: Icon(
        Icons.login,
        size: 20,
      ),
      onTap: () {
        Navigator.pushNamed(context, 'adminlogin');
      },
    );
  }

  Widget addAudio() {
    if (isAdmin) {
      return ListTile(
        trailing: Icon(
          Icons.add,
          size: 30,
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

  information() {
    return ListTile(
      trailing: Icon(
        Icons.info,
        size: 30,
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

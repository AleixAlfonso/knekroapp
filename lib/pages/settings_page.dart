import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:knekroapp/controllers/ad_state.dart';
import 'package:knekroapp/pages/config/config.dart';
import 'package:knekroapp/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  BannerAd? banner2;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);

    adState.initialization.then(
      (status) {
        setState(() {
          banner2 = BannerAd(
              adUnitId: adState.banner2,
              size: AdSize.banner,
              request: AdRequest(),
              listener: BannerAdListener())
            ..load();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuracion'),
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(3),
                child: Container(
                  height: 60,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.blue.shade50],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    trailing: Icon(
                      Icons.brightness_medium,
                      size: mediaQuery.size.height * 0.03,
                      color: Colors.blue,
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
                ),
              ),
              addAudio(mediaQuery),
              isAdmin ? cerrarSesion(mediaQuery) : iniciarSesion(mediaQuery),
              information(mediaQuery),
            ],
          ),
        ),
        if (banner2 == null)
          SizedBox(
            height: 50,
          )
        else
          Container(
            height: 50,
            child: AdWidget(ad: banner2!),
          )
      ]),
    );
  }

  Widget cerrarSesion(MediaQueryData mediaQuery) {
    return Padding(
      padding: EdgeInsets.all(3),
      child: Container(
        height: 60,
        alignment: Alignment.bottomLeft,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.blue.shade50],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          trailing: Icon(
            Icons.logout,
            size: mediaQuery.size.height * 0.03,
            color: Colors.blue,
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
        ),
      ),
    );
  }

  Widget iniciarSesion(MediaQueryData mediaQuery) {
    return Padding(
        padding: EdgeInsets.all(3),
        child: Container(
          height: 60,
          alignment: Alignment.bottomLeft,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.blue.shade50],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            title: Text('Admin Log In'),
            trailing: Icon(
              Icons.login,
              size: mediaQuery.size.height * 0.03,
              color: Colors.blue,
            ),
            onTap: () {
              Navigator.pushNamed(context, 'adminlogin');
            },
          ),
        ));
  }

  Widget addAudio(MediaQueryData mediaQuery) {
    if (isAdmin) {
      return Padding(
          padding: EdgeInsets.all(3),
          child: Container(
              height: 60,
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blue.shade50],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                trailing: Icon(
                  Icons.add,
                  size: mediaQuery.size.height * 0.04,
                  color: Colors.blue,
                ),
                title: Text(
                  'Añadir audio',
                ),
                onTap: () {
                  Navigator.pushNamed(context, 'addaudio');
                },
              )));
    }
    return Container();
  }

  information(MediaQueryData mediaQuery) {
    return Padding(
      padding: EdgeInsets.all(3),
      child: Container(
        height: 60,
        alignment: Alignment.bottomLeft,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.blue.shade50],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          trailing: Icon(
            Icons.info,
            size: mediaQuery.size.height * 0.03,
            color: Colors.blue,
          ),
          title: Text(
            'Información',
          ),
          onTap: () {
            Navigator.pushNamed(context, 'infopage');
          },
        ),
      ),
    );
  }
}

import 'package:knekroapp/pages/addAudio_page.dart';
import 'package:knekroapp/pages/info.dart';
import 'package:knekroapp/pages/login_page.dart';
import 'package:knekroapp/pages/main_page.dart';
import 'package:knekroapp/pages/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/authentication_setvices.dart';
import 'pages/config/config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    getDarkmode();
    currentTheme.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  Future getDarkmode() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    setState(() {
      if (sharedPreferences.getBool('darkmode') == null) {
      } else {
        isDark = sharedPreferences.getBool('darkmode')!;
      }
    });
    print(isAdmin);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: MainPage(),
        routes: {
          'mainpage': (context) => MainPage(),
          'settingsPage': (context) => SettingsPage(),
          'adminlogin': (context) => Authentication(),
          'addaudio': (context) => AddAudio(),
          'infopage': (context) => InfoPage()
        },
        themeMode: currentTheme.currentTheme(),
        theme: isDark ? ThemeData.dark() : ThemeData.light(),
        darkTheme: ThemeData.dark(),
      ),
    );
  }
}

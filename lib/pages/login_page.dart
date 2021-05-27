import 'package:knekroapp/controllers/authentication_setvices.dart';
import 'package:knekroapp/pages/config/config.dart';
import 'package:flutter/material.dart';
import 'package:knekroapp/pages/main_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController userController = new TextEditingController();
    TextEditingController passwordController = new TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Login Page'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            TextField(
              controller: userController,
              decoration: InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
            ),
            ElevatedButton(
                onPressed: () async {
                  final SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  String string = await context
                      .read<AuthenticationService>()
                      .signIn(userController.text.trim(),
                          passwordController.text.trim());

                  if ('signed in' == string) {
                    isAdmin = true;
                    sharedPreferences.setBool('isAdmin', true);

                    Navigator.pushAndRemoveUntil<void>(
                      context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) => MainPage()),
                      ModalRoute.withName('mainpage'),
                    );
                  } else if ('signed in' != string) {
                    showAlertDialog(context);
                  }
                },
                child: Text('Entrar'))
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = ElevatedButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alerta"),
      content: Text("Error al iniciar sesion, compruebe los datos."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

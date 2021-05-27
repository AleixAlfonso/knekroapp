import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:knekroapp/models/audio_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/config.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String finalEmail = '';
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('audios');
  AudioPlayer audioPlayer = new AudioPlayer();

  // ignore: deprecated_member_use

  @override
  initState() {
    getValidationData();
    super.initState();
  }

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    setState(() {
      if (sharedPreferences.getBool('isAdmin') == null) {
      } else {
        isAdmin = sharedPreferences.getBool('isAdmin')!;
      }
    });
    print(isAdmin);
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> ds = new Map<String, dynamic>();
    List<Audio> audios = [];
    return Scaffold(
      appBar: AppBar(
        title: Text('Frases Knekro'),
        actions: <Widget>[
          FloatingActionButton(
            child: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, 'settingsPage');
            },
          ),
        ],
      ),
      // body: Container(child: crearListView(context)),
      body: StreamBuilder<Object>(
        stream: FirebaseFirestore.instance.collection('audios').snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          audios.clear();
          for (var doc in snapshot.data.docs) {
            ds.addAll(doc.data());
            audios.add(Audio(
                titulo: ds['titulo'],
                rutaAudio: ds['rutaAudio'],
                icono: ds['icono'],
                id: doc.id));
          }

          return ListView.builder(
              itemCount: audios.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(audios[index].icono),
                  ),
                  title: Text(audios[index].titulo),
                  onTap: () async {
                    await audioPlayer.play(audios[index].rutaAudio);
                  },
                  trailing: deleteAudio(audios[index].id),
                );
              });
        },
      ),
    );
  }

  deleteAudio(String id) {
    if (isAdmin == false) return;
    return IconButton(
        onPressed: () {
          showAlertDialog(context, id);
        },
        icon: Icon(Icons.close));
  }

  showAlertDialog(BuildContext context, id) {
    // set up the button
    Widget okButton = ElevatedButton(
      child: Text("OK"),
      onPressed: () {
        FirebaseFirestore.instance.collection('audios').doc(id).delete();
        Navigator.of(context).pop();
      },
    );
    Widget cancelButton = ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
          setState(() {});
        },
        child: Text('Cancelar'));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alerta"),
      content: Text("Estas seguro que quieres eliminar el audio ?"),
      actions: [
        cancelButton,
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

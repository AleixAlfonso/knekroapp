import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:knekroapp/controllers/ad_state.dart';
import 'package:knekroapp/models/audio_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'config/config.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Future<SharedPreferences> sharedPreferences = SharedPreferences.getInstance();
  String finalEmail = '';
  BannerAd? banner;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('audios');
  AudioPlayer audioPlayer = new AudioPlayer();
  bool novedad = false;
  bool isInterstitialReady = false;

  // ignore: deprecated_member_use
  ReceivePort receivePort = ReceivePort();
  int progress = 0;

  @override
  initState() {
    _checkVersion(context);
    IsolateNameServer.registerPortWithName(
        receivePort.sendPort, "downloadingaudio");
    receivePort.listen((message) {
      setState(() {
        progress = message;
      });
    });
    FlutterDownloader.registerCallback(downloadCallback);
    getValidationData();
    super.initState();
  }

  static downloadCallback(id, status, progress) {
    SendPort? sendPort = IsolateNameServer.lookupPortByName("downloadingaudio");
    sendPort!.send(progress);
  }

  @override
  void dispose() {
    super.dispose();
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

  void _checkVersion(BuildContext context) async {
    final newVersion = NewVersion(androidId: 'com.aleix.knekroapp');
    // newVersion.showAlertIfNecessary(context: context);
    final status = await newVersion.getVersionStatus();
    if (status!.localVersion != status.storeVersion) {
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'Actualización disponible.',
        dismissButtonText: 'Cancelar',
        dialogText: 'Porfavor actualiza la aplicacion a la version ' +
            '${status.storeVersion}' +
            ' para un correcto funcionamiento.',
        dismissAction: () {
          SystemNavigator.pop();
        },
        updateButtonText: 'Actualizar!',
      );
    }
    print('DEVICE: ' + status.localVersion);
    print('STORE; ' + status.storeVersion);
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> ds = new Map<String, dynamic>();
    List<Audio> audios = [];
    final adState = Provider.of<AdState>(context);

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
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<Object>(
              stream:
                  FirebaseFirestore.instance.collection('audios').snapshots(),
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
                      id: doc.id,
                      fecha: ds['fecha']));
                }

                return ListView.builder(
                  itemCount: audios.length,
                  itemBuilder: (BuildContext context, int index) {
                    audios.sort(
                      (a, b) => b.fecha.compareTo(a.fecha),
                    );

                    String titulo = '';
                    DateTime fechaAudio = DateTime.parse(
                      audios[index].fecha.toString(),
                    );
                    DateTime now = DateTime.now();
                    int days = now.difference(fechaAudio).inDays;

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
                          leading: Icon(Icons.play_circle_fill),
                          // leading: CircleAvatar(
                          //   backgroundImage: AssetImage(audios[index].icono),
                          // ),
                          title: RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(text: '${audios[index].titulo}'),
                                days < 7
                                    ? TextSpan(
                                        text: '  NOVEDAD ',
                                        style: TextStyle(
                                            color: Colors.red.shade300,
                                            fontSize: 20))
                                    : TextSpan(),
                              ],
                            ),
                          ),
                          onTap: () async {
                            await audioPlayer.play(audios[index].rutaAudio);
                          },
                          trailing: crearTrailing(
                              audios[index].id, audios[index], adState),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (banner == null)
            SizedBox(
              height: 50,
            )
          else
            Container(
              height: 50,
              child: AdWidget(ad: banner!),
            )
        ],
      ),
    );
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
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

  crearTrailing(String id, Audio audio, AdState adState) {
    if (isAdmin) {
      return IconButton(
          onPressed: () {
            showAlertDialog(context, id);
          },
          icon: Icon(Icons.close));
    } else if (!isAdmin) {
      return IconButton(
        onPressed: () async {
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.setInt('contadorDescargas',
              sharedPreferences.getInt('contadorDescargas')! + 1);
          final status = await Permission.storage.request();

          if (status.isGranted) {
            Directory? _externalDocumentsDirectory =
                await getExternalStorageDirectory();
            print(_externalDocumentsDirectory!.path);
            final id = await FlutterDownloader.enqueue(
                url: audio.rutaAudio,
                savedDir: _externalDocumentsDirectory.path,
                fileName: audio.titulo);
          } else {
            print("no permission0");
          }
          if (sharedPreferences.getInt('contadorDescargas')! % 5 == 0) {
            showDonationDialog(context, id,
                'https://www.paypal.com/donate?hosted_button_id=UQNC9MVWDQCSA');
          }
        },
        icon: Icon(Icons.download, color: Colors.blue),
      );
    }
  }

  showDonationDialog(BuildContext context, id, String utlpaypal) {
    // set up the button
    Widget okButton = ElevatedButton(
      child: Text("Apoyar"),
      onPressed: () async {
        await canLaunch(utlpaypal)
            ? await launch(utlpaypal)
            : throw 'Could not launch $utlpaypal';
        Navigator.of(context).pop();
      },
    );
    Widget cancelButton = ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
          setState(() {});
        },
        child: Text('No gracias.'));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Apoyo."),
      content: Text("Recuerda apoyar al creador de la app. Todo cuenta!"),
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

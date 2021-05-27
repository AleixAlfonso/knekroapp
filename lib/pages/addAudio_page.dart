import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:knekroapp/controllers/bd_controller.dart';

import 'main_page.dart';

class AddAudio extends StatefulWidget {
  @override
  _AddAudioState createState() => _AddAudioState();
}

class _AddAudioState extends State<AddAudio> {
  String urlDownload = '';
  List<Map> imagenes = [
    {
      'imagen': 'assets/Genshin.png',
    },
    {
      'imagen': 'assets/SeaOfThieves.png',
    },
    {
      'imagen': 'assets/LeagueOfLegends.png',
    },
    {
      'imagen': 'assets/Miscelanea.png',
    },
    {
      'imagen': 'assets/Overcooked.png',
    },
    {
      'imagen': 'assets/Donacion.png',
    },
    {
      'imagen': 'assets/DeadByDaylight.png',
    },
    {
      'imagen': 'assets/PUBG.png',
    },
  ];
  String? _selected;
  UploadTask? task;

  File? file;
  final TextEditingController tituloController = new TextEditingController();
  final TextEditingController tituloAudioController =
      new TextEditingController();
  final TextEditingController dropbutton = new TextEditingController();
  dynamic path;
  String? filename;

  String valorEscogido = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Audio'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            color: Colors.grey,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: tituloAudioController,
                    decoration: InputDecoration(labelText: 'Titulo'),
                  ),
                  Row(
                    children: [
                      Text(tituloController.text),
                      IconButton(
                        icon: Icon(
                          Icons.save,
                        ),
                        onPressed: () async {
                          path = await FilePicker.platform.pickFiles();
                          tituloController.text = path.names[0];
                          final finalpath = path.files.single.path!;
                          setState(() {
                            file = File(finalpath);
                            filename = path.names[0];
                          });
                        },
                      ),
                    ],
                  ),
                  DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        hint: Text('Selecciona imagen'),
                        value: _selected,
                        onChanged: (newValue) {
                          setState(() {
                            _selected = newValue;
                            dropbutton.text = newValue
                                .toString()
                                .substring(7, newValue.toString().length - 4);
                          });
                        },
                        items: imagenes.map((valor) {
                          return DropdownMenuItem<String>(
                            value: valor['imagen'].toString(),
                            child: Row(
                              children: [
                                Image.asset(
                                  valor['imagen'],
                                  width: 25,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(valor['imagen']
                                      .toString()
                                      .substring(
                                          7,
                                          valor['imagen'].toString().length -
                                              4)),
                                )
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ElevatedButton(
                      child: Text('Guardar Audio'),
                      onPressed: () async {
                        if (_selected.toString().isEmpty ||
                            file == null ||
                            tituloAudioController.text.isEmpty) {
                          showAlertDialog(context,
                              'Tienes que informar de los 3 datos: Titulo, audio e imagen.');
                        } else if (p.extension(filename!) != '.mp3') {
                          showAlertDialog(context,
                              'El archivo solamente puede ser un .mp3');
                        } else {
                          uploadFile();
                        }
                        print(_selected);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, String mensaje) {
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
      content: Text(mensaje),
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

  Future uploadFile() async {
    if (file == null) return;
    final destination = 'files/$filename';
    task = FirebaseApi.uploadFile(destination, file!);
    if (task == null) return;
    final snapshot = await task!.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL();
    print('Download-link: $urlDownload');
    FirebaseApi.uploadAudio(
      _selected.toString(),
      urlDownload,
      tituloAudioController.text,
    );
    Navigator.pushAndRemoveUntil<void>(
      context,
      MaterialPageRoute<void>(builder: (BuildContext context) => MainPage()),
      ModalRoute.withName('mainpage'),
    );
  }
}

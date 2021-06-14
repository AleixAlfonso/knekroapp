import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
      // ignore: unused_catch_clause
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static UploadTask? uploadBytes(String destination, Uint8List data) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putData(data);
      // ignore: unused_catch_clause
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static UploadTask? uploadAudio(
    String icono,
    String rutaAudio,
    String titulo,
  ) {
    var date = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(date);

    print(formattedDate);
    FirebaseFirestore.instance.collection('audios').doc().set({
      'icono': icono,
      'rutaAudio': rutaAudio,
      'titulo': titulo,
      'fecha': formattedDate,
    });
  }
}

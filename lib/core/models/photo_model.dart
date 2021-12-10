import 'package:cloud_firestore/cloud_firestore.dart';

class PhotoModel {
  String? filename;
  String? date;

  PhotoModel({this.filename, this.date});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "filename": filename,
      "date": date,
    };

    return map;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  String? filename;
  String? date;

  BannerModel({this.filename, this.date});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "filename": filename,
      "date": date,
    };

    return map;
  }
}

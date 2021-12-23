import 'package:cloud_firestore/cloud_firestore.dart';

class DiscographyModel {
  int? number;
  String? title;
  Timestamp? date;
  String? description;

  DiscographyModel({this.number, this.title, this.date, this.description});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "number": number,
      "title": title,
      "date": date,
      "description": description
    };

    return map;
  }
}

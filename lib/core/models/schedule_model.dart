import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleModel {
  String? id;
  String? title;
  String? place;
  String? description;
  Timestamp? dateini;
  Timestamp? dateend;
  bool? view;

  ScheduleModel({
    this.id,
    this.title,
    this.place,
    this.description,
    this.dateini,
    this.dateend,
    this.view,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "title": title,
      "place": place,
      "description": description,
      "dateini": dateini,
      "dateend": dateend,
      "view": view,
    };

    return map;
  }
}

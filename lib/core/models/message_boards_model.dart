import 'package:cloud_firestore/cloud_firestore.dart';

class MessageBoardsModel {
  String? id;
  String? name;
  String? place;
  String? message;
  Timestamp? date;
  bool? view;

  MessageBoardsModel(
      {this.id, this.name, this.place, this.message, this.date, this.view});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "name": name,
      "place": place,
      "message": message,
      "date": date,
      "view": view
    };

    return map;
  }
}

class ScheduleModel {
  String? id;
  String? title;
  String? description;
  DateTime? dateini;
  DateTime? dateend;
  bool? view;

  ScheduleModel(
      {this.id,
      this.title,
      this.description,
      this.dateini,
      this.dateend,
      this.view});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "title": title,
      "description": description,
      "date_ini": dateini,
      "date_end": dateend,
      "view": view
    };

    return map;
  }
}

class ScheduleModel {
  String? id;
  String? title;
  String? description;
  DateTime? date;

  ScheduleModel({this.id, this.title, this.description, this.date});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "title": title,
      "description": description,
      "date": date
    };

    return map;
  }
}

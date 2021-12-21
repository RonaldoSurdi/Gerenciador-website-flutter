class DiscographyModel {
  String? id;
  int? number;
  String? title;
  DateTime? date;
  String? description;

  DiscographyModel(
      {this.id, this.number, this.title, this.date, this.description});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "number": number,
      "title": title,
      "date": date,
      "description": description
    };

    return map;
  }
}

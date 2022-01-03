class PhotoModel {
  String? id;
  String? description;
  String? place;
  String? date;

  PhotoModel({this.id, this.description, this.place, this.date});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "description": description,
      "place": place,
      "date": date
    };

    return map;
  }
}

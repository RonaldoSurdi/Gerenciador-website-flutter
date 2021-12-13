class PhotoModel {
  String? description;
  String? date;
  int? count;

  PhotoModel({this.description, this.date, this.count});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "description": description,
      "date": date,
      "count": count
    };

    return map;
  }
}

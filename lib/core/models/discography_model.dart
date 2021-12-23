class DiscographyModel {
  int? number;
  String? title;
  String? date;
  String? description;
  String? filename;
  String? musics;

  DiscographyModel({
    this.number,
    this.title,
    this.date,
    this.description,
    this.filename,
    this.musics,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "number": number,
      "title": title,
      "date": date,
      "description": description,
      "filename": filename,
      "musics": musics,
    };

    return map;
  }
}

class DiscModel {
  num? id;
  String? title;
  num? year;
  String? info;
  String? image;

  DiscModel({
    this.id,
    this.title,
    this.year,
    this.info,
    this.image,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "title": title,
      "year": year,
      "info": info,
      "image": image,
    };

    return map;
  }
}

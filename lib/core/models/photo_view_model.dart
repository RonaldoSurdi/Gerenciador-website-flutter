class PhotoViewModel {
  String? id;
  String? description;
  String? place;
  String? date;
  String? image;

  PhotoViewModel({
    this.id,
    this.description,
    this.place,
    this.date,
    this.image,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "description": description,
      "place": place,
      "date": date,
      "image": image
    };

    return map;
  }
}

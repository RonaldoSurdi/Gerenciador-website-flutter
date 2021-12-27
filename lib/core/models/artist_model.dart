class ArtistModel {
  String? id;
  String? name;
  String? info;
  String? image;

  ArtistModel({
    this.id,
    this.name,
    this.info,
    this.image,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "name": name,
      "info": info,
      "image": image,
    };

    return map;
  }
}

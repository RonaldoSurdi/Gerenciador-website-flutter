class AlbumModel {
  String? id;
  String? description;
  String? image;

  AlbumModel({this.id, this.description, this.image});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "description": description,
      "image": image
    };

    return map;
  }
}

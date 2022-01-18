class PhotoImageModel {
  String? id;
  String? image;

  PhotoImageModel({this.id, this.image});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {"id": id, "image": image};

    return map;
  }
}

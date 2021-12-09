class MediaModel {
  String? filename;

  MediaModel({this.filename});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {"filename": filename};

    return map;
  }
}

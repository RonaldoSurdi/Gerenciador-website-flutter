class DownloadModel {
  String? id;
  String? title;
  String? description;
  String? group;
  String? file;

  DownloadModel({
    this.id,
    this.title,
    this.description,
    this.group,
    this.file,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "title": title,
      "description": description,
      "group": group,
      "file": file,
    };

    return map;
  }
}

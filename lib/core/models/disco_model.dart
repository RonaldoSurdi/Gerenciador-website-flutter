class DiscoModel {
  String? id;
  int? number;
  String? title;
  String? path;
  String? video;
  String? letter;
  DateTime? cipher;

  DiscoModel(
      {this.id,
      this.number,
      this.title,
      this.path,
      this.video,
      this.letter,
      this.cipher});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "number": number,
      "title": title,
      "path": path,
      "video": video,
      "letter": letter,
      "cipher": cipher
    };

    return map;
  }
}

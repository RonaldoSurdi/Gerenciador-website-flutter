class VideoModel {
  String? date;
  String? title;
  String? image;
  String? watch;

  VideoModel({this.date, this.title, this.image, this.watch});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "date": date,
      "title": title,
      "image": image,
      "watch": watch
    };

    return map;
  }
}

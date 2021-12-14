class VideoModel {
  String? date;
  String? title;
  String? watch;

  VideoModel({this.date, this.title, this.watch});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {"date": date, "title": title, "watch": watch};

    return map;
  }
}

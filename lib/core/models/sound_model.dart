class SoundModel {
  num? track;
  String? title;
  String? info;
  String? movie;
  String? lyric;
  String? cipher;
  String? audio;

  SoundModel({
    this.track,
    this.title,
    this.info,
    this.movie,
    this.lyric,
    this.cipher,
    this.audio,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "track": track,
      "title": title,
      "info": info,
      "movie": movie,
      "lyric": lyric,
      "cipher": cipher,
      "audio": audio,
    };

    return map;
  }
}

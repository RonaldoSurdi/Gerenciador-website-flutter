class SettingsModel {
  String? name;
  String? email;
  int? videostype;
  String? channelid;

  SettingsModel({this.name, this.email, this.videostype, this.channelid});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {"name": name, "email": email, "videostype": videostype, "channelid": channelid};

    return map;
  }
}

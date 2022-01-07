class SettingsModel {
  String? name;
  String? email;
  int? videostype;
  String? channelid;
  String? smtphost;
  int? smtpport;
  bool? smtpsecure;
  String? smtpuser;
  String? smtppass;

  SettingsModel({
    this.name,
    this.email,
    this.videostype,
    this.channelid,
    this.smtphost,
    this.smtpport,
    this.smtpsecure,
    this.smtpuser,
    this.smtppass,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "name": name,
      "email": email,
      "videostype": videostype,
      "channelid": channelid,
      "smtphost": smtphost,
      "smtpport": smtpport,
      "smtpsecure": smtpsecure,
      "smtpuser": smtpuser,
      "smtppass": smtppass
    };

    return map;
  }
}

class SettingsprivateModel {
  String? smtphost;
  int? smtpport;
  bool? smtpsecure;
  String? smtpuser;
  String? smtppass;

  SettingsprivateModel({
    this.smtphost,
    this.smtpport,
    this.smtpsecure,
    this.smtpuser,
    this.smtppass,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "smtphost": smtphost,
      "smtpport": smtpport,
      "smtpsecure": smtpsecure,
      "smtpuser": smtpuser,
      "smtppass": smtppass
    };

    return map;
  }
}

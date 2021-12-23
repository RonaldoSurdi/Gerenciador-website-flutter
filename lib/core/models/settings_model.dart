class SettingsModel {
  String? name;
  String? email;

  SettingsModel({this.name, this.email});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {"name": name, "email": email};

    return map;
  }
}

class BiographyData {
  String? description;

  BiographyData({ this.description });

  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {
      "description" : description
    };

    return map;

  }
}
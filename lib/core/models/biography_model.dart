class BiographyModel {
  String? description;

  BiographyModel({ this.description });

  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {
      "description" : description
    };

    return map;

  }
}
class UserModel {
  String? nome;
  String? email;
  String? password;

  UserModel({this.nome, this.email, this.password});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nome": nome,
      "email": email,
      "password": password
    };

    return map;
  }
}

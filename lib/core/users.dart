class Users {
  String? nome;
  String? email;
  String? password;

  Users({ this.nome, this.email, this.password });

  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {
      "nome" : nome,
      "email" : email
    };

    return map;

  }
}
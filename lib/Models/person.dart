

class Person {
  int? id;
  String? name;
  String? email;
  dynamic emailVerifiedAt;
  String? ketua;
  String? role;
  dynamic lastLogin;
  String? createdAt;
  String? updatedAt;

  Person({this.id, this.name, this.email, this.emailVerifiedAt, this.ketua, this.role, this.lastLogin, this.createdAt, this.updatedAt});

  Person.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["email"] is String) {
      email = json["email"];
    }
    emailVerifiedAt = json["email_verified_at"];
    if(json["ketua"] is String) {
      ketua = json["ketua"];
    }
    if(json["role"] is String) {
      role = json["role"];
    }
    lastLogin = json["last_login"];
    if(json["created_at"] is String) {
      createdAt = json["created_at"];
    }
    if(json["updated_at"] is String) {
      updatedAt = json["updated_at"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["email"] = email;
    _data["email_verified_at"] = emailVerifiedAt;
    _data["ketua"] = ketua;
    _data["role"] = role;
    _data["last_login"] = lastLogin;
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    return _data;
  }
}

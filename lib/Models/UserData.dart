class UserData {
  final int id;
  final String name;
  final String email;
  final String ketua;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.ketua,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      ketua: json['ketua'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'ketua': ketua,
    };
  }
}
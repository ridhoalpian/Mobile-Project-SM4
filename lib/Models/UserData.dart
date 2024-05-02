class UserData {
  final int id;
  final String? name;
  final String? email;
  final String? ketua;
  final String role;
  final DateTime? lastLogin;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserData({
    required this.id,
    this.name,
    this.email,
    this.ketua,
    required this.role,
    this.lastLogin,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
  return UserData(
    id: json['id'],
    name: json['name'] != null ? json['name'] : '', 
    email: json['email'] != null ? json['email'] : '', 
    ketua: json['ketua'] != null ? json['ketua'] : '', 
    role: json['role'],
    lastLogin: json['last_login'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );
}

}

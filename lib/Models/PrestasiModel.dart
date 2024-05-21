class Prestasi {
  final int id;
  final int userId;
  final String namalomba;
  final String kategorilomba;
  final String tanggallomba;
  final String juara;
  final String penyelenggara;
  final String lingkup;
  final String sertifikat;
  final String dokumentasi;
  final String statusprestasi;

  Prestasi({
    required this.id,
    required this.userId,
    required this.namalomba,
    required this.kategorilomba,
    required this.tanggallomba,
    required this.juara,
    required this.penyelenggara,
    required this.lingkup,
    required this.sertifikat,
    required this.dokumentasi,
    required this.statusprestasi,
  });

  factory Prestasi.fromJson(Map<String, dynamic> json) {
    return Prestasi(
      id: json['id'],
      userId: json['user_id'],
      namalomba: json['namalomba'],
      kategorilomba: json['kategorilomba'],
      tanggallomba: json['tanggallomba'],
      juara: json['juara'],
      penyelenggara: json['penyelenggara'],
      lingkup: json['lingkup'],
      sertifikat: json['sertifikat'],
      dokumentasi: json['dokumentasi'],
      statusprestasi: json['statusprestasi'],
    );
  }
}

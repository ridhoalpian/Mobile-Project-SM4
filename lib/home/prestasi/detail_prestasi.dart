import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projectone/database/apiutils.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PrestasiDetailPage extends StatefulWidget {
  final Map<String, dynamic> prestasi;
  final bool isEditable;

  PrestasiDetailPage({required this.prestasi, required this.isEditable});

  @override
  _PrestasiDetailPageState createState() => _PrestasiDetailPageState();
}

class _PrestasiDetailPageState extends State<PrestasiDetailPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _namaLombaController;
  late TextEditingController _tanggalLombaController;
  late TextEditingController _penyelenggaraController;
  File? _sertifikatFile;
  File? _dokumentasiFile;
  final ImagePicker _picker = ImagePicker();

  String _selectedKategori = 'individu';
  String _selectedJuara = 'Juara 1';
  String _selectedLingkup = 'kabupaten';

  @override
  void initState() {
    super.initState();
    _namaLombaController =
        TextEditingController(text: widget.prestasi['namalomba']);
    _tanggalLombaController =
        TextEditingController(text: widget.prestasi['tanggallomba']);
    _penyelenggaraController =
        TextEditingController(text: widget.prestasi['penyelenggara']);

    _selectedKategori = widget.prestasi['kategorilomba'];
    _selectedJuara = widget.prestasi['juara'];
    _selectedLingkup = widget.prestasi['lingkup'];
  }

  @override
  void dispose() {
    _namaLombaController.dispose();
    _tanggalLombaController.dispose();
    _penyelenggaraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Prestasi',
            style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0), // Height of the line
          child: Container(
            color: Colors.grey, // Color of the line
            height: 0.2, // Height of the line
          ),
        ),
        actions: [
          if (widget.isEditable)
            TextButton(
              onPressed: _updatePrestasi,
              child: Text(
                'Simpan',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                TextFormField(
                  controller: _namaLombaController,
                  readOnly: !widget.isEditable,
                  decoration: _buildDropDownDecoration(
                      labelText: 'Nama Lomba',
                      prefixIcon: Icons.text_snippet_rounded),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama Lomba harus diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _penyelenggaraController,
                  readOnly: !widget.isEditable,
                  decoration: _buildDropDownDecoration(
                      labelText: 'Penyelenggara', prefixIcon: Icons.business),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Penyelenggara harus diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  readOnly: !widget.isEditable,
                  onTap: () async {
                    if (widget.isEditable) {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate:
                            DateTime.parse(_tanggalLombaController.text),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Colors.green[400]!,
                              ),
                              buttonTheme: ButtonThemeData(
                                textTheme: ButtonTextTheme.primary,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null &&
                          picked !=
                              DateTime.parse(_tanggalLombaController.text)) {
                        setState(() {
                          _tanggalLombaController.text =
                              picked.toIso8601String();
                        });
                      }
                    }
                  },
                  decoration: _buildDropDownDecoration(
                      labelText: 'Tanggal Lomba',
                      prefixIcon: Icons.calendar_today),
                  controller: _tanggalLombaController,
                ),
                SizedBox(height: 10),
                Divider(
                  color: Colors.grey, // Warna garis
                  thickness: 0.2, // Ketebalan garis
                ),
                SizedBox(height: 10),
                DropdownButtonFormField2<String>(
                  value: _selectedLingkup,
                  onChanged: widget.isEditable
                      ? (value) {
                          setState(() {
                            _selectedLingkup = value!;
                          });
                        }
                      : null,
                  items: ['kabupaten', 'provinsi', 'nasional', 'lainnya']
                      .map((String lingkup) {
                    return DropdownMenuItem<String>(
                      value: lingkup,
                      child: Text(lingkup),
                    );
                  }).toList(),
                  decoration: _buildDropDownDecoration(
                      labelText: 'Lingkup Lomba',
                      prefixIcon: Icons.location_on),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField2<String>(
                  value: _selectedKategori,
                  onChanged: widget.isEditable
                      ? (value) {
                          setState(() {
                            _selectedKategori = value!;
                          });
                        }
                      : null,
                  items: ['individu', 'kelompok'].map((String kategori) {
                    return DropdownMenuItem<String>(
                      value: kategori,
                      child: Text(kategori),
                    );
                  }).toList(),
                  decoration: _buildDropDownDecoration(
                      labelText: 'Kategori Lomba', prefixIcon: Icons.people),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField2<String>(
                  value: _selectedJuara,
                  onChanged: widget.isEditable
                      ? (value) {
                          setState(() {
                            _selectedJuara = value!;
                          });
                        }
                      : null,
                  items: [
                    'Juara 1',
                    'Juara 2',
                    'Juara 3',
                    'Harapan 1',
                    'Harapan 2',
                    'lainnya'
                  ].map((String juara) {
                    return DropdownMenuItem<String>(
                      value: juara,
                      child: Text(juara),
                    );
                  }).toList(),
                  decoration: _buildDropDownDecoration(
                      labelText: 'Juara', prefixIcon: Icons.emoji_events),
                ),
                SizedBox(height: 10),
                Divider(
                  color: Colors.grey, // Warna garis
                  thickness: 0.2, // Ketebalan garis
                ),
                SizedBox(height: 10),
                Text(
                  'Pilih gambar dengan ukuran maksimum 2048 kB.',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
                SizedBox(height: 10),
                _buildImagePicker(
                  context,
                  label: 'Pilih Sertifikat',
                  icon: Icons.photo,
                  onTap: widget.isEditable ? _pickSertifikatFile : null,
                ),
                SizedBox(height: 10),
                _buildSertifikatImage(),
                SizedBox(height: 10),
                _buildImagePicker(
                  context,
                  label: 'Pilih Dokumentasi',
                  icon: Icons.photo,
                  onTap: widget.isEditable ? _pickDokumentasiFile : null,
                ),
                SizedBox(height: 10),
                _buildDokumentasiImage(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updatePrestasi() async {
    if (_formKey.currentState!.validate()) {
      var url = Uri.parse(
          ApiUtils.buildUrl('api/prestasi/${widget.prestasi['idprestasi']}'));
      var request = http.MultipartRequest('POST', url)
        ..fields['user_id'] = widget.prestasi['user_id'].toString()
        ..fields['namalomba'] = _namaLombaController.text
        ..fields['kategorilomba'] = _selectedKategori
        ..fields['tanggallomba'] = _tanggalLombaController.text
        ..fields['juara'] = _selectedJuara
        ..fields['penyelenggara'] = _penyelenggaraController.text
        ..fields['lingkup'] = _selectedLingkup
        ..fields['statusprestasi'] = widget.prestasi['statusprestasi'];

      if (_sertifikatFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'sertifikat', _sertifikatFile!.path));
      }

      if (_dokumentasiFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'dokumentasi', _dokumentasiFile!.path));
      }

      var response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        AnimatedSnackBar.rectangle(
          'Success',
          'Data prestasi berhasil disimpan',
          type: AnimatedSnackBarType.success,
          brightness: Brightness.light,
          duration: Duration(seconds: 4),
        ).show(context);
        Navigator.pop(context, true);
      } else {
        AnimatedSnackBar.rectangle(
          'Error',
          'Gagal menyimpan data',
          type: AnimatedSnackBarType.error,
          brightness: Brightness.light,
          duration: Duration(seconds: 4),
        ).show(context);
      }
    }
  }

  Future<void> _pickSertifikatFile() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _sertifikatFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickDokumentasiFile() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _dokumentasiFile = File(pickedFile.path);
      });
    }
  }

  Widget _buildSertifikatImage() {
    if (_sertifikatFile != null) {
      return Container(
        width: double.infinity,
        height: 200,
        child: Image.file(
          _sertifikatFile!,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Image.network(
        ApiUtils.buildUrl('storage/${widget.prestasi['sertifikat']}'),
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      );
    }
  }

  Widget _buildDokumentasiImage() {
    if (_dokumentasiFile != null) {
      return Container(
        width: double.infinity,
        height: 200,
        child: Image.file(
          _dokumentasiFile!,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Image.network(
        ApiUtils.buildUrl('storage/${widget.prestasi['dokumentasi']}'),
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      );
    }
  }

  Widget _buildImagePicker(BuildContext context,
      {required String label,
      required IconData icon,
      required VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.green[50],
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 30, color: Colors.green[400]),
              SizedBox(width: 20),
              Text(
                label,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildDropDownDecoration(
      {String? labelText, IconData? prefixIcon}) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.grey),
      border: InputBorder.none,
      filled: true,
      fillColor: Colors.grey[200],
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
    );
  }
}

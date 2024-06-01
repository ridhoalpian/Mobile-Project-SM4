import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projectone/database/apiutils.dart';
import 'package:projectone/database/dbhelper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PrestasiForm extends StatefulWidget {
  @override
  _PrestasiFormState createState() => _PrestasiFormState();
}

class _PrestasiFormState extends State<PrestasiForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? _userId;
  TextEditingController _namaLombaController = TextEditingController();
  String _selectedKategori = 'individu';
  DateTime _selectedDate = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  String _selectedJuara = 'Juara 1';
  TextEditingController _penyelenggaraController = TextEditingController();
  String _selectedLingkup = 'kabupaten';
  File? _sertifikatFile;
  File? _dokumentasiFile;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Form Prestasi',
            style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0), // Height of the line
          child: Container(
            color: Colors.grey, // Color of the line
            height: 0.2, // Height of the line
          ),
        ),
        actions: [
          TextButton(
            onPressed: _submitForm,
            child: Text(
              'Simpan',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white, // Set background color to white
        child: SingleChildScrollView(
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
                    controller: _dateController,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    decoration: _buildDropDownDecoration(
                        labelText: 'Tanggal Lomba',
                        prefixIcon: Icons.calendar_today),
                  ),
                  SizedBox(height: 10),
                  Divider(
                    color: Colors.grey, // Warna garis
                    thickness: 0.2, // Ketebalan garis
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField2<String>(
                    value: _selectedLingkup,
                    onChanged: (value) {
                      setState(() {
                        _selectedLingkup = value!;
                      });
                    },
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
                    onChanged: (value) {
                      setState(() {
                        _selectedKategori = value!;
                      });
                    },
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
                    onChanged: (value) {
                      setState(() {
                        _selectedJuara = value!;
                      });
                    },
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
                    'Unggah gambar dengan ukuran maksimum 2048 kB',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                  SizedBox(height: 10),
                  _buildImagePicker(
                    context,
                    label: 'Pilih Sertifikat',
                    icon: Icons.photo,
                    onTap: _pickSertifikatFile,
                  ),
                  SizedBox(height: 10),
                  _sertifikatFile != null
                      ? Container(
                          height: 200,
                          width: double.infinity,
                          child: Image.file(
                            _sertifikatFile!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Text(
                          'Belum ada sertifikat yang dipilih.',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                  SizedBox(height: 20),
                  _buildImagePicker(
                    context,
                    label: 'Pilih Dokumentasi',
                    icon: Icons.photo,
                    onTap: _pickDokumentasiFile,
                  ),
                  SizedBox(height: 10),
                  _dokumentasiFile != null
                      ? Container(
                          height: 200,
                          width: double.infinity,
                          child: Image.file(
                            _dokumentasiFile!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Text(
                          'Belum ada dokumentasi yang dipilih.',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                  SizedBox(height: 20),
                ],
              ),
            ),
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

  Future<void> _loadUserId() async {
    int? userId = await DBHelper.getUserId();
    setState(() {
      _userId = userId;
    });
  }

  Future<void> _submitForm() async {
    if (_userId == null) {
      AnimatedSnackBar.rectangle(
        'Error',
        'User ID tidak ditemukan',
        type: AnimatedSnackBarType.error,
        brightness: Brightness.light,
        duration: Duration(seconds: 4),
      ).show(context);
      return;
    }

    var url = Uri.parse(ApiUtils.buildUrl('api/prestasi'));
    var request = http.MultipartRequest('POST', url)
      ..fields['user_id'] = _userId.toString()
      ..fields['namalomba'] = _namaLombaController.text
      ..fields['kategorilomba'] = _selectedKategori
      ..fields['tanggallomba'] = _selectedDate.toIso8601String()
      ..fields['juara'] = _selectedJuara
      ..fields['penyelenggara'] = _penyelenggaraController.text
      ..fields['lingkup'] = _selectedLingkup;

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

  Widget _buildImagePicker(BuildContext context,
      {required String label,
      required IconData icon,
      required VoidCallback onTap}) {
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

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green[400]!, // Ganti warna tombol "OK"
            ),
            buttonTheme: ButtonThemeData(
              textTheme:
                  ButtonTextTheme.primary, // Ganti warna teks tombol "OK"
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text =
            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';
      });
    }
  }
}

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

  Future<void> _loadUserId() async {
    int? userId = await DBHelper.getUserId();
    setState(() {
      _userId = userId;
    });
  }

  Future<void> _submitForm() async {
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('User ID tidak ditemukan.'),
      ));
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
      request.files.add(await http.MultipartFile.fromPath('sertifikat', _sertifikatFile!.path));
    }

    if (_dokumentasiFile != null) {
      request.files.add(await http.MultipartFile.fromPath('dokumentasi', _dokumentasiFile!.path));
    }

    var response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data prestasi berhasil disimpan'),
      ));
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Gagal menyimpan data'),
      ));
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

  OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(color: Colors.grey),
  );

  OutlineInputBorder _focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(color: Colors.grey),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Prestasi'),
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
                  decoration: InputDecoration(
                    labelText: 'Nama Lomba',
                    border: _outlineInputBorder,
                    focusedBorder: _focusedBorder,
                    prefixIcon: Icon(Icons.sports),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama Lomba harus diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
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
                  decoration: InputDecoration(
                    labelText: 'Kategori Lomba',
                    border: _outlineInputBorder,
                    focusedBorder: _focusedBorder,
                    prefixIcon: Icon(Icons.category),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  readOnly: true,
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != _selectedDate) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Tanggal Lomba',
                    border: _outlineInputBorder,
                    focusedBorder: _focusedBorder,
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                    text: '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
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
                  decoration: InputDecoration(
                    labelText: 'Juara',
                    border: _outlineInputBorder,
                    focusedBorder: _focusedBorder,
                    prefixIcon: Icon(Icons.emoji_events),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _penyelenggaraController,
                  decoration: InputDecoration(
                    labelText: 'Penyelenggara',
                    border: _outlineInputBorder,
                    focusedBorder: _focusedBorder,
                    prefixIcon: Icon(Icons.business),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Penyelenggara harus diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
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
                  decoration: InputDecoration(
                    labelText: 'Lingkup Lomba',
                    border: _outlineInputBorder,
                    focusedBorder: _focusedBorder,
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _pickSertifikatFile();
                  },
                  child: Text('Pilih Sertifikat'),
                ),
                SizedBox(height: 10),
                _sertifikatFile != null
                    ? Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                        child: Image.file(
                          _sertifikatFile!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : SizedBox(), // Jika belum ada file dipilih, tampilkan SizedBox
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _pickDokumentasiFile();
                  },
                  child: Text('Pilih Dokumentasi'),
                ),
                SizedBox(height: 10),
                _dokumentasiFile != null
                    ? Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                        child: Image.file(
                          _dokumentasiFile!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : SizedBox(), // Jika belum ada file dipilih, tampilkan SizedBox
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _submitForm();
                    }
                  },
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.amber,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

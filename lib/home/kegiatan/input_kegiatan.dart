import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:projectone/database/apiutils.dart';

class InputKegiatan extends StatefulWidget {
  final int userId;

  InputKegiatan({required this.userId});

  @override
  _InputKegiatanState createState() => _InputKegiatanState();
}

class _InputKegiatanState extends State<InputKegiatan> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _namaKegiatanController = TextEditingController();
  final TextEditingController _penanggungJawabController =
      TextEditingController();
  final TextEditingController _pengajuanDanaController =
      TextEditingController();
  String? _selectedProker;
  String? _selectedFile;

  List<Map<String, dynamic>> prokerItems = [];
  @override
  void initState() {
    super.initState();
    _fetchProkerData();
  }

  int _getCurrentYear() {
    return DateTime.now().year;
  }

  Future<void> _fetchProkerData() async {
    final response = await http.get(
        Uri.parse(ApiUtils.buildUrl('api/proker?user_id=${widget.userId}')));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      setState(() {
        prokerItems = data
            .map((item) => {
                  'idproker': item['idproker'],
                  'nama_proker': item['nama_proker'],
                })
            .toList();
      });
    } else {
      AnimatedSnackBar.rectangle(
        'Error',
        'Gagal mengambil data proker',
        type: AnimatedSnackBarType.error,
        brightness: Brightness.light,
        duration: Duration(seconds: 4),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Pengajuan Kegiatan',
            style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey,
            height: 0.2,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                _submitForm();
              }
            },
            child: Text(
              'Simpan',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        // WidgetSpan(
                        //   child: Icon(Icons.error, color: Colors.red, size: 16),
                        // ),
                        TextSpan(
                          text:
                              'Untuk pengajuan kegiatan harus sudah terdapat tanda tangan pembina Ormawa atau BEM',
                          style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Divider(
                color: Colors.grey,
                thickness: 0.2,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField2<String>(
                decoration: _buildInputDecoration(
                  labelText: 'Pilih Proker',
                  prefixIcon: Icons.work,
                ),
                items: prokerItems.map((item) {
                  return DropdownMenuItem<String>(
                    value: item['idproker'].toString(),
                    child: Text('${item['idproker']}. ${item['nama_proker']}'),
                  );
                }).toList(),
                validator: (value) =>
                    value == null ? 'Anda belum memilih Proker' : null,
                onChanged: (value) {
                  setState(() {
                    _selectedProker = value;
                  });
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _namaKegiatanController,
                decoration: _buildInputDecoration(
                  labelText: 'Nama Kegiatan',
                  prefixIcon: Icons.event,
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Nama Kegiatan wajib diisi'
                    : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _penanggungJawabController,
                decoration: _buildInputDecoration(
                  labelText: 'Penanggung Jawab',
                  prefixIcon: Icons.person,
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Penanggung Jawab wajib diisi'
                    : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: _buildInputDecoration(
                  labelText: 'Periode',
                  prefixIcon: Icons.calendar_today,
                ),
                initialValue: _getCurrentYear().toString(),
                readOnly: true,
              ),
              SizedBox(height: 10),
              Divider(
                color: Colors.grey,
                thickness: 0.2,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _pengajuanDanaController,
                decoration: _buildInputDecoration(
                  labelText: 'Pengajuan Dana',
                  prefixIcon: Icons.attach_money,
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Pengajuan Dana wajib diisi'
                    : null,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: _buildInputDecoration(
                        labelText: 'Proposal Kegiatan',
                        prefixIcon: Icons.description,
                      ),
                      readOnly: true,
                      controller: TextEditingController(text: _selectedFile),
                      onTap: _openFilePicker,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.attach_file),
                    onPressed: _openFilePicker,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(Icons.error, color: Colors.red, size: 16),
                        ),
                        TextSpan(
                          text:
                              '  Pilih file berformat .pdf dengan ukuran maksimum 2048 kB',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(
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

  Future<void> _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = result.files.single.path!;
      });
    }
  }

  Future<void> _submitForm() async {
    final userId = widget.userId;
    final periode = _getCurrentYear();

    // ignore: unnecessary_null_comparison
    if (userId == null) {
      AnimatedSnackBar.rectangle(
        'Error',
        'User ID tidak ditemukan',
        type: AnimatedSnackBarType.error,
        brightness: Brightness.light,
        duration: Duration(seconds: 4),
      ).show(context);
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final uri = Uri.parse(ApiUtils.buildUrl('api/kegiatan'));
    final request = http.MultipartRequest('POST', uri);

    request.fields['nama_kegiatan'] = _namaKegiatanController.text;
    request.fields['penanggung_jawab'] = _penanggungJawabController.text;
    request.fields['pengajuan_dana'] = _pengajuanDanaController.text;
    request.fields['periode'] = periode.toString();
    request.fields['proker_id'] = _selectedProker!;
    request.fields['user_id'] = userId.toString();

    if (_selectedFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'proposal_kegiatan', _selectedFile!));
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      AnimatedSnackBar.rectangle(
        'Success',
        'Data kegiatan berhasil disimpan',
        type: AnimatedSnackBarType.success,
        brightness: Brightness.light,
        duration: Duration(seconds: 4),
      ).show(context);
      Navigator.pop(context, true);
    } else {
      AnimatedSnackBar.rectangle(
        'Error',
        'Gagal menyimpan data kegiatan',
        type: AnimatedSnackBarType.error,
        brightness: Brightness.light,
        duration: Duration(seconds: 4),
      ).show(context);
    }
  }
}

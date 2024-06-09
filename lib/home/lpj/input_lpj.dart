import 'dart:convert';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projectone/database/apiutils.dart';

class InputLPJ extends StatefulWidget {
  final int userId;

  InputLPJ({required this.userId});

  @override
  _InputLPJState createState() => _InputLPJState();
}

class _InputLPJState extends State<InputLPJ> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _selectedProker;
  String? _selectedFile;

  List<Map<String, dynamic>> prokerItems = [];

  @override
  void initState() {
    super.initState();
    _fetchProkerData();
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
        title: Text('Input Pengajuan LPJ',
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
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
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: _buildInputDecoration(
                            labelText: 'File LPJ',
                            prefixIcon: Icons.description,
                          ),
                          readOnly: true,
                          controller: TextEditingController(text: _selectedFile),
                          onTap: _openFilePicker,
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Lampiran LPJ diperlukan' : null,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.attach_file),
                        onPressed: _openFilePicker,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    final userId = widget.userId;

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

    final uri = Uri.parse(ApiUtils.buildUrl('api/lpj'));
    final request = http.MultipartRequest('POST', uri);

    request.fields['proker_id'] = _selectedProker!;
    request.fields['user_id'] = userId.toString();

    if (_selectedFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'file_lpj', _selectedFile!));
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      AnimatedSnackBar.rectangle(
        'Success',
        'Data LPJ berhasil disimpan',
        type: AnimatedSnackBarType.success,
        brightness: Brightness.light,
        duration: Duration(seconds: 4),
      ).show(context);
      Navigator.pop(context, true);
    } else {
      AnimatedSnackBar.rectangle(
        'Error',
        'Gagal menyimpan data LPJ',
        type: AnimatedSnackBarType.error,
        brightness: Brightness.light,
        duration: Duration(seconds: 4),
      ).show(context);
    }
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
}

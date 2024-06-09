import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:projectone/database/DBHelper.dart';
import 'package:http/http.dart' as http;
import 'package:projectone/database/apiutils.dart';
import 'package:http_parser/http_parser.dart';

class InputProker extends StatefulWidget {
  @override
  _InputProkerState createState() => _InputProkerState();
}

class _InputProkerState extends State<InputProker> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedFile;
  int? _userId;

  TextEditingController _namaProkerController = TextEditingController();
  TextEditingController _deskripsiProkerController = TextEditingController();
  TextEditingController _penanggungJawabController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Input Proker', style: TextStyle(fontWeight: FontWeight.bold)),
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
                _saveProker();
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
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _namaProkerController,
                    decoration: _buildInputDecoration(
                      labelText: 'Nama Proker',
                      prefixIcon: Icons.work,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama Proker harus diisi';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _deskripsiProkerController,
                    decoration: _buildInputDecoration(
                      labelText: 'Deskripsi Proker',
                      prefixIcon: Icons.description,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _penanggungJawabController,
                    decoration: _buildInputDecoration(
                      labelText: 'Penanggung Jawab',
                      prefixIcon: Icons.person,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Penanggung Jawab harus diisi';
                      }
                      return null;
                    },
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
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: _buildInputDecoration(
                            labelText: 'Lampiran LPJ',
                            prefixIcon: Icons.description,
                          ),
                          readOnly: true,
                          controller:
                              TextEditingController(text: _selectedFile),
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
                              child: Icon(Icons.error,
                                  color: Colors.red, size: 16),
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
        ),
      ),
    );
  }

  int _getCurrentYear() {
    return DateTime.now().year;
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

  Future<void> _saveProker() async {
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

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final namaProker = _namaProkerController.text;
    final deskripsiProker = _deskripsiProkerController.text;
    final penanggungJawab = _penanggungJawabController.text;
    final periode = _getCurrentYear();

    var url = Uri.parse(ApiUtils.buildUrl('api/proker'));
    var request = http.MultipartRequest('POST', url)
      ..fields['user_id'] = _userId.toString()
      ..fields['nama_proker'] = namaProker
      ..fields['uraian_proker'] = deskripsiProker
      ..fields['penanggung_jawab'] = penanggungJawab
      ..fields['periode'] = periode.toString();

    if (_selectedFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'lampiran_proker',
        _selectedFile!,
        contentType: MediaType('application', 'pdf'),
      ));
    }

    var response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      AnimatedSnackBar.rectangle(
        'Success',
        'Data proker berhasil disimpan',
        type: AnimatedSnackBarType.success,
        brightness: Brightness.light,
        duration: Duration(seconds: 4),
      ).show(context);
      Navigator.pop(context, true);
    } else {
      AnimatedSnackBar.rectangle(
        'Error',
        'Gagal menyimpan data proker',
        type: AnimatedSnackBarType.error,
        brightness: Brightness.light,
        duration: Duration(seconds: 4),
      ).show(context);
    }
  }

  Future<void> _loadUserId() async {
    int? userId = await DBHelper.getUserId();
    setState(() {
      _userId = userId;
    });
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
}

import 'dart:io';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:projectone/database/apiutils.dart';
import 'package:url_launcher/url_launcher.dart';

class detailLPJ extends StatefulWidget {
  final Map<String, dynamic> lpj;
  final bool isEditable;

  detailLPJ({required this.lpj, required this.isEditable});

  @override
  _DetailLPJState createState() => _DetailLPJState();
}

class _DetailLPJState extends State<detailLPJ> {
  final TextEditingController _namaUKMController = TextEditingController();
  final TextEditingController _namaProkerController = TextEditingController();
  final TextEditingController _penanggungJawabController =
      TextEditingController();
  final TextEditingController _uraianProkerController = TextEditingController();
  final TextEditingController _periodeController = TextEditingController();
  final TextEditingController _statusLPJController = TextEditingController();
  String? _selectedPdfPath;

  @override
  void initState() {
    super.initState();
    _namaUKMController.text = widget.lpj['user_name'];
    _namaProkerController.text = widget.lpj['nama_proker'];
    _penanggungJawabController.text = widget.lpj['penanggung_jawab'];
    _uraianProkerController.text = widget.lpj['uraian_proker'];
    _periodeController.text = widget.lpj['periode'];
    _statusLPJController.text = widget.lpj['status_lpj'];
  }

  Future<void> _downloadFile() async {
    setState(() {});
    String fileUrl = ApiUtils.buildUrl('storage/${widget.lpj['file_lpj']}');

    try {
      var request = await http.get(Uri.parse(fileUrl));
      var bytes = request.bodyBytes;
      String downloadsPath = '/storage/emulated/0/Download';
      String fullPath = '$downloadsPath/${widget.lpj['nama_proker']}_lpj.pdf';

      File file = File(fullPath);
      await file.writeAsBytes(bytes);

      setState(() {});
      AnimatedSnackBar.rectangle(
        'Success',
        'File LPJ berhasil diunduh',
        type: AnimatedSnackBarType.success,
        brightness: Brightness.light,
        duration: Duration(seconds: 4),
      ).show(context);

      launch(fullPath);
    } catch (e) {
      setState(() {});
      AnimatedSnackBar.rectangle(
        'Error',
        'Gagal mengunduh file LPJ',
        type: AnimatedSnackBarType.error,
        brightness: Brightness.light,
        duration: Duration(seconds: 4),
      ).show(context);
    }
  }

  Future<void> _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedPdfPath = result.files.single.path!;
      });
    }
  }

  InputDecoration _buildInputDecoration(
      {required String labelText, IconData? prefixIcon}) {
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

  Future<void> _saveLPJ() async {
    if (_selectedPdfPath == null) {
      AnimatedSnackBar.rectangle(
        'Error',
        'Pilih file PDF terlebih dahulu',
        type: AnimatedSnackBarType.error,
        brightness: Brightness.light,
        duration: Duration(seconds: 4),
      ).show(context);
      return;
    }

    var url =
        Uri.parse(ApiUtils.buildUrl('api/lpj/${widget.lpj['idlpj']}'));
    var request = http.MultipartRequest('POST', url);

    if (_selectedPdfPath != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'file_lpj',
        _selectedPdfPath!,
        contentType: MediaType('application', 'pdf'),
      ));
    }

    // Optional: Menambahkan status_proker ke form fields
    request.fields['status_lpj'] = widget.lpj['status_lpj'];

    var response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      AnimatedSnackBar.rectangle(
        'Success',
        'LPJ berhasil diperbarui',
        type: AnimatedSnackBarType.success,
        brightness: Brightness.light,
        duration: Duration(seconds: 4),
      ).show(context);
      Navigator.pop(context, true);
    } else {
      print('Error: ${response.reasonPhrase}');
      AnimatedSnackBar.rectangle(
        'Error',
        'Gagal memperbarui LPJ',
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
        title:
            Text('Detail LPJ', style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey,
            height: 0.2,
          ),
        ),
        actions: [
          if (widget.isEditable)
            TextButton(
              onPressed: _saveLPJ,
              child: Text(
                'Simpan',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _namaUKMController,
                readOnly: true,
                decoration: _buildInputDecoration(
                  labelText: 'Nama UKM',
                  prefixIcon: Icons.group,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _namaProkerController,
                readOnly: true,
                decoration: _buildInputDecoration(
                  labelText: 'Nama Proker',
                  prefixIcon: Icons.event_note,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _penanggungJawabController,
                readOnly: true,
                decoration: _buildInputDecoration(
                  labelText: 'Penanggung Jawab',
                  prefixIcon: Icons.person,
                ),
              ),
              SizedBox(height: 10),
              Divider(color: Colors.grey, thickness: 0.2),
              SizedBox(height: 10),
              TextFormField(
                controller: _uraianProkerController,
                readOnly: true,
                decoration: _buildInputDecoration(
                  labelText: 'Uraian Proker',
                  prefixIcon: Icons.description,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _periodeController,
                readOnly: true,
                decoration: _buildInputDecoration(
                  labelText: 'Periode',
                  prefixIcon: Icons.date_range,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _statusLPJController,
                readOnly: true,
                decoration: _buildInputDecoration(
                  labelText: 'Status LPJ',
                  prefixIcon: Icons.info_outline,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  if (widget.isEditable)
                  Expanded(
                    child: TextFormField(
                      decoration: _buildInputDecoration(
                        labelText: 'File LPJ',
                        prefixIcon: Icons.description,
                      ),
                      readOnly: true,
                      controller: TextEditingController(text: _selectedPdfPath),
                      onTap: _openFilePicker,
                    ),
                  ),
                  if (widget.isEditable)
                  IconButton(
                    icon: Icon(Icons.attach_file),
                    onPressed: _openFilePicker,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildButtonDownload(
              context,
              label: 'Unduh Lampiran',
              icon: Icons.download_rounded,
              onTap: _downloadFile,
            ),
            Wrap(
              children: [
                Text(
                  'File PDF yang berhasil diunduh akan masuk kedalam folder Download',
                  style: TextStyle(fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePicker() {
    return GestureDetector(
      onTap: _downloadFile,
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
              Icon(Icons.file_download, size: 30, color: Colors.green[400]),
              SizedBox(width: 20),
              Text(
                'Unduh File LPJ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonDownload(BuildContext context,
      {required String label,
      required IconData icon,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.indigo[50],
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 30, color: Colors.indigo[400]),
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
}

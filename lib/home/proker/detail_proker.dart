import 'dart:io';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:projectone/database/apiutils.dart';
import 'package:http_parser/http_parser.dart';
import 'package:url_launcher/url_launcher.dart';

class ProkerDetail extends StatefulWidget {
  final Map<String, dynamic> proker;
  final bool isEditable;

  ProkerDetail({required this.proker, required this.isEditable});

  @override
  _ProkerDetailState createState() => _ProkerDetailState();
}

class _ProkerDetailState extends State<ProkerDetail> {
  String? _selectedPdfPath;
  String? _selectedFileName;

  final TextEditingController _namaProkerController = TextEditingController();
  final TextEditingController _deskripsiProkerController =
      TextEditingController();
  final TextEditingController _penanggungJawabController =
      TextEditingController();
  final TextEditingController _periodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _namaProkerController.text = widget.proker['nama_proker'];
    _deskripsiProkerController.text = widget.proker['uraian_proker'];
    _penanggungJawabController.text = widget.proker['penanggung_jawab'];
    _periodeController.text = widget.proker['periode'].toString();
  }

  Future<void> _downloadPdf() async {
    setState(() {});

    String pdfUrl =
        ApiUtils.buildUrl('storage/${widget.proker['lampiran_proker']}');

    try {
      var request = await http.get(Uri.parse(pdfUrl));
      var bytes = request.bodyBytes;
      String downloadsPath =
          '/storage/emulated/0/Download'; // Path to the public Downloads directory
      String fullPath =
          '$downloadsPath/${widget.proker['nama_proker']}_lampiran.pdf';

      File file = File(fullPath);
      await file.writeAsBytes(bytes);

      setState(() {});
      AnimatedSnackBar.rectangle(
        'Success',
        'File PDF berhasil diunduh',
        type: AnimatedSnackBarType.success,
        brightness: Brightness.light,
        duration: Duration(seconds: 6),
      ).show(context);

      // Launch the file after download
      launch(fullPath);
    } catch (e) {
      setState(() {});
      AnimatedSnackBar.rectangle(
        'Error',
        'Gagal mengunduh file PDF',
        type: AnimatedSnackBarType.error,
        brightness: Brightness.light,
        duration: Duration(seconds: 4),
      ).show(context);
    }
  }

  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedPdfPath = result.files.single.path!;
        _selectedFileName = result.files.single.name;
      });
    }
  }

  Future<void> _saveProker() async {
    if (_selectedPdfPath == null) {
      AnimatedSnackBar.rectangle(
        'Error',
        'Pilih lampiran PDF terlebih dahulu',
        type: AnimatedSnackBarType.error,
        brightness: Brightness.light,
        duration: Duration(seconds: 4),
      ).show(context);
      return;
    }

    var url =
        Uri.parse(ApiUtils.buildUrl('api/proker/${widget.proker['idproker']}'));
    var request = http.MultipartRequest('POST', url);

    if (_selectedPdfPath != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'lampiran_proker',
        _selectedPdfPath!,
        contentType: MediaType('application', 'pdf'),
      ));
    }

    // Optional: Menambahkan status_proker ke form fields
    request.fields['status_proker'] = widget.proker['status_proker'];

    var response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      AnimatedSnackBar.rectangle(
        'Success',
        'Lampiran Proker berhasil diperbarui',
        type: AnimatedSnackBarType.success,
        brightness: Brightness.light,
        duration: Duration(seconds: 4),
      ).show(context);

      Navigator.pop(context, true);
    } else {
      print('Error: ${response.reasonPhrase}');
      AnimatedSnackBar.rectangle(
        'Error',
        'Gagal memperbarui lampiran proker',
        type: AnimatedSnackBarType.error,
        brightness: Brightness.light,
        duration: Duration(seconds: 4),
      ).show(context);
    }
  }

  Widget _buildButtonDownload(BuildContext context,
      {required String label,
      required IconData icon,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.orange[50],
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 30, color: Colors.orange[400]),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Proker',
            style: TextStyle(fontWeight: FontWeight.bold)),
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
              onPressed: _saveProker,
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
                controller: _namaProkerController,
                readOnly: true,
                decoration: _buildDropDownDecoration(
                  labelText: 'Nama Proker',
                  prefixIcon: Icons.event_note,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _deskripsiProkerController,
                readOnly: true,
                decoration: _buildDropDownDecoration(
                  labelText: 'Deskripsi Proker',
                  prefixIcon: Icons.description,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _penanggungJawabController,
                readOnly: true,
                decoration: _buildDropDownDecoration(
                  labelText: 'Penanggung Jawab',
                  prefixIcon: Icons.person,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _periodeController,
                readOnly: true,
                decoration: _buildDropDownDecoration(
                  labelText: 'Periode',
                  prefixIcon: Icons.date_range,
                ),
              ),
              SizedBox(height: 10),
              if (widget.isEditable)
                Divider(
                  color: Colors.grey,
                  thickness: 0.2,
                ),
              SizedBox(height: 10),
              Row(
                children: [
                  if (widget.isEditable)
                    Expanded(
                      child: TextFormField(
                        controller:
                            TextEditingController(text: _selectedFileName),
                        readOnly: true,
                        decoration: _buildDropDownDecoration(
                          labelText: 'Pilih File Proker',
                          prefixIcon: Icons.description,
                        ),
                        onTap: _pickPdf,
                      ),
                    ),
                  if (widget.isEditable)
                    IconButton(
                      icon: Icon(Icons.attach_file),
                      onPressed: _pickPdf,
                    ),
                ],
              ),
              SizedBox(height: 10),
              if (widget.isEditable)
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child:
                                Icon(Icons.error, color: Colors.red, size: 16),
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
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildButtonDownload(
              context,
              label: 'Unduh Lampiran',
              icon: Icons.download_rounded,
              onTap: _downloadPdf,
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

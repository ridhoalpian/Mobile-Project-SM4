import 'dart:io';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:projectone/database/apiutils.dart';
import 'package:url_launcher/url_launcher.dart';

class detailKegiatan extends StatefulWidget {
  final Map<String, dynamic> kegiatan;
  final bool isEditable;

  detailKegiatan({required this.kegiatan, required this.isEditable});

  @override
  _detailKegiatanState createState() => _detailKegiatanState();
}

class _detailKegiatanState extends State<detailKegiatan> {
  final TextEditingController _namaKegiatanController = TextEditingController();
  final TextEditingController _penanggungJawabController =
      TextEditingController();
  final TextEditingController _pengajuanDanaController =
      TextEditingController();
  final TextEditingController _danaCairController = TextEditingController();
  final TextEditingController _periodeController = TextEditingController();
  final TextEditingController _statusKegiatanController =
      TextEditingController();
  String? _selectedFile;

  @override
  void initState() {
    super.initState();
    _namaKegiatanController.text =
        widget.kegiatan['nama_kegiatan']?.toString() ?? '';
    _penanggungJawabController.text =
        widget.kegiatan['penanggung_jawab']?.toString() ?? '';
    _pengajuanDanaController.text =
        formatRupiah(widget.kegiatan['pengajuan_dana']);
    _danaCairController.text = formatRupiah(widget.kegiatan['dana_cair']);
    _periodeController.text = widget.kegiatan['periode']?.toString() ?? '';
    _statusKegiatanController.text =
        widget.kegiatan['status_kegiatan']?.toString() ?? '';
  }

  String formatRupiah(dynamic amount) {
    if (amount == null) {
      return 'Rp. 0';
    }
    if (amount is String) {
      amount = double.tryParse(amount) ?? 0;
    }
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ');
    return formatter.format(amount);
  }

  Future<void> _downloadFile() async {
    setState(() {});
    String fileUrl =
        ApiUtils.buildUrl('storage/${widget.kegiatan['proposal_kegiatan']}');

    try {
      var request = await http.get(Uri.parse(fileUrl));
      var bytes = request.bodyBytes;
      String downloadsPath = '/storage/emulated/0/Download';
      String fullPath =
          '$downloadsPath/${widget.kegiatan['nama_kegiatan']}_kegiatan.pdf';

      File file = File(fullPath);
      await file.writeAsBytes(bytes);

      setState(() {});
      AnimatedSnackBar.rectangle(
        'Success',
        'Proposal Kegiatan berhasil diunduh',
        type: AnimatedSnackBarType.success,
        brightness: Brightness.light,
        duration: Duration(seconds: 4),
      ).show(context);

      launch(fullPath);
    } catch (e) {
      setState(() {});
      AnimatedSnackBar.rectangle(
        'Error',
        'Gagal mengunduh proposal kegiatan',
        type: AnimatedSnackBarType.error,
        brightness: Brightness.light,
        duration: Duration(seconds: 4),
      ).show(context);
    }
  }

  Future<void> _saveProposal() async {
    if (_selectedFile == null) {
      AnimatedSnackBar.rectangle(
        'Error',
        'Pilih file PDF terlebih dahulu',
        type: AnimatedSnackBarType.error,
        brightness: Brightness.light,
        duration: Duration(seconds: 4),
      ).show(context);
      return;
    }

    var url = Uri.parse(
        ApiUtils.buildUrl('api/kegiatan/${widget.kegiatan['idkegiatan']}'));
    var request = http.MultipartRequest('POST', url);

    if (_selectedFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'proposal_kegiatan',
        _selectedFile!,
        contentType: MediaType('application', 'pdf'),
      ));
    }

    // Optional: Menambahkan status_kegiatan ke form fields
    request.fields['status_kegiatan'] = widget.kegiatan['status_kegiatan'];

    var response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      AnimatedSnackBar.rectangle(
        'Success',
        'Proposal Kegiatan berhasil diperbarui',
        type: AnimatedSnackBarType.success,
        brightness: Brightness.light,
        duration: Duration(seconds: 4),
      ).show(context);

      Navigator.pop(context, true);
    } else {
      print('Error: ${response.reasonPhrase}');
      AnimatedSnackBar.rectangle(
        'Error',
        'Gagal memperbarui proposal kegiatan',
        type: AnimatedSnackBarType.error,
        brightness: Brightness.light,
        duration: Duration(seconds: 4),
      ).show(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Kegiatan',
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
              onPressed: _saveProposal,
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
                controller: _namaKegiatanController,
                readOnly: true,
                decoration: _buildInputDecoration(
                  labelText: 'Nama Kegiatan',
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
                controller: _statusKegiatanController,
                readOnly: true,
                decoration: _buildInputDecoration(
                  labelText: 'Status Kegiatan',
                  prefixIcon: Icons.info_outline,
                ),
              ),
              SizedBox(height: 10),
              Divider(color: Colors.grey, thickness: 0.2),
              SizedBox(height: 10),
              TextFormField(
                controller: _pengajuanDanaController,
                readOnly: true,
                decoration: _buildInputDecoration(
                  labelText: 'Pengajuan Dana',
                  prefixIcon: Icons.monetization_on,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _danaCairController,
                readOnly: true,
                decoration: _buildInputDecoration(
                  labelText: 'Dana Cair',
                  prefixIcon: Icons.money,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  if (widget.isEditable)
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
                  if (widget.isEditable)
                  IconButton(
                    icon: Icon(Icons.attach_file),
                    onPressed: _openFilePicker,
                  ),
                ],
              ),
              SizedBox(height: 10),
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

  Widget _buildButtonDownload(BuildContext context,
      {required String label,
      required IconData icon,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.cyan[50],
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 30, color: Colors.cyan[400]),
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
                'Unduh Proposal Kegiatan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

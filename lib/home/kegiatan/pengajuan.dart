import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class pengajuanKegiatan extends StatefulWidget {
  @override
  _pengajuanKegiatanState createState() => _pengajuanKegiatanState();
}

class _pengajuanKegiatanState extends State<pengajuanKegiatan> {
  final List<String> genderItems = [
    'Proker 1',
    'Proker 2',
    'Proker 3',
    'Proker 4',
  ];

  String? selectedValue;

  OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(color: Colors.grey), // Warna border default
  );

  OutlineInputBorder _focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(color: Colors.grey), // Warna border saat diklik
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Pengajuan Kegiatan',
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Untuk pengajuan kegiatan harus sudah terdapat tanda tangan pembina ormawa atau BEM',
              style: TextStyle(fontSize: 14, color: Colors.red),
            ),
            SizedBox(height: 10),
            Divider(
              color: Colors.black12,
              thickness: 1,
            ),
            SizedBox(height: 10),
            DropdownButtonFormField2<String>(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.work),
                  border: _outlineInputBorder,
                  focusedBorder: _focusedBorder,
                  hintText: 'Pilih Proker'),
              items: genderItems
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                        ),
                      ))
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return 'Anda belum memilih Proker';
                }
                return null;
              },
              onChanged: (value) {
                //Do something when selected item is changed.
              },
              onSaved: (value) {
                selectedValue = value.toString();
              },
              iconStyleData: const IconStyleData(
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black45,
                ),
                iconSize: 24,
              ),
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Nama Kegiatan',
                border: _outlineInputBorder,
                focusedBorder: _focusedBorder,
                prefixIcon: Icon(
                  Icons.event,
                ),
                labelStyle: TextStyle(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Penanggung Jawab',
                border: _outlineInputBorder,
                focusedBorder: _focusedBorder,
                prefixIcon: Icon(
                  Icons.person,
                ),
                labelStyle: TextStyle(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Periode',
                border: _outlineInputBorder,
                focusedBorder: _focusedBorder,
                prefixIcon: Icon(
                  Icons.calendar_today,
                ),
                labelStyle: TextStyle(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Pengajuan Dana',
                border: _outlineInputBorder,
                focusedBorder: _focusedBorder,
                prefixIcon: Icon(
                  Icons.attach_money,
                ),
                labelStyle: TextStyle(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Lampiran LPJ',
                border: _outlineInputBorder,
                focusedBorder: _focusedBorder,
                suffixIcon: InkWell(
                  onTap: () {
                    _openFilePicker(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.attach_file,
                    ),
                  ),
                ),
                prefixIcon: Icon(
                  Icons.description,
                ),
                labelStyle: TextStyle(),
              ),
              readOnly: true,
              onTap: () {
                _openFilePicker(context);
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.green[400]!, width: 2),
                    ),
                  ),
                  child: Container(
                    constraints: BoxConstraints(minWidth: 88, minHeight: 44),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.delete, color: Colors.black54),
                        SizedBox(width: 8),
                        Text(
                          "Hapus",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green[400],
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Container(
                    constraints: BoxConstraints(minWidth: 88, minHeight: 44),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.send, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "Kirim",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openFilePicker(BuildContext context) {
    // Open file picker dialog or navigator
  }
}

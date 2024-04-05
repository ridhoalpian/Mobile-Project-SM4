import 'package:flutter/material.dart';

class LpjPage extends StatefulWidget {
  @override
  _LpjPageState createState() => _LpjPageState();
}

class _LpjPageState extends State<LpjPage> {
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFF5F7C5D),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    "Pengajuan LPJ",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ),
                ),
                SizedBox(width: 10),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(color: Color(0xFF5F7C5D)),
                    ),
                  ),
                  child: Text(
                    "Data LPJ",
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF5F7C5D),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              child: DropdownButton<String>(
                isExpanded: true,
                value: dropdownValue,
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                hint: Text('Pilih Proker'),
                items: const [
                  DropdownMenuItem<String>(
                    value: 'proker1',
                    child: Text('Proker 1'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'proker2',
                    child: Text('Proker 2'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Lampiran LPJ',
                labelStyle:
                    TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
                prefixIcon: Container(
                  margin: EdgeInsets.only(
                      right: 8),
                  child: TextButton(
                    onPressed: () {
                      _openFilePicker(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      "Choose File",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ),
                contentPadding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                floatingLabelBehavior: FloatingLabelBehavior.never,
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
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFFF34235),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    "Hapus",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ),
                ),
                SizedBox(width: 10),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFF3CA2BA),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    "Kirim",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
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

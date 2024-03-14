import 'package:flutter/material.dart';
import 'package:projectone/register/login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isObscured = true;
  TextEditingController _dateController = TextEditingController();
  String dropdownValue = 'lakik';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
            child: Image.asset(
              'assets/images/logo_bem_polije.jpg',
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Registrasi",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(40, 20, 40, 5),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Nama Lengkap",
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(40, 0, 40, 5),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Username",
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(40, 0, 40, 5),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(40, 5, 40, 5),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Password",
                suffixIcon: IconButton(
                  icon: _isObscured
                      ? Icon(Icons.visibility_off)
                      : Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                ),
              ),
              obscureText: _isObscured,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(40, 5, 40, 5),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Konfirmasi Password",
                suffixIcon: IconButton(
                  icon: _isObscured
                      ? Icon(Icons.visibility_off)
                      : Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                ),
              ),
              obscureText: _isObscured,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(40, 5, 40, 5),
            child: TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: "Tanggal Lahir",
              ),
              readOnly: true,
              onTap: () {
                _selectedDate();
              },
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(40, 5, 40, 5),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Alamat Lengkap",
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(40, 15, 40, 5),
            child: DropdownButton<String>(
              isExpanded: true,
              value: dropdownValue,
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: const [
                DropdownMenuItem<String>(
                  value: 'lakik',
                  child: Text('Laki-Laki'),
                ),
                DropdownMenuItem<String>(
                  value: 'cewe',
                  child: Text('Perempuan'),
                ),
              ],
            ),
          ),
          
          Container(
            padding: EdgeInsets.fromLTRB(40, 40, 40, 5),
            height: 100,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                elevation: 10,
                backgroundColor: Color(0xFF5F7C5D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                "Daftar",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sudah punya akun?",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text(
                  " Login",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _selectedDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
      });
    }
  }
}

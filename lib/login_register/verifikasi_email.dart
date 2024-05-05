import 'package:flutter/material.dart';
import 'package:projectone/login_register/pass_baru.dart';

class verif_email extends StatefulWidget {
  const verif_email({Key? key});

  @override
  _verif_emailState createState() => _verif_emailState();
}

class _verif_emailState extends State<verif_email> {
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  TextEditingController _controller4 = TextEditingController();

  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  FocusNode _focusNode3 = FocusNode();
  FocusNode _focusNode4 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verifikasi Email',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildCodeInputField(_controller1, _focusNode1),
                _buildCodeInputField(_controller2, _focusNode2),
                _buildCodeInputField(_controller3, _focusNode3),
                _buildCodeInputField(_controller4, _focusNode4),
              ],
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {},
              child: Text(
                "Kirim ulang kode OTP",
                style: TextStyle(
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 40),
            Container(
              height: 60,
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => passBaru()),
                      );
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF5F7C5D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                    side: BorderSide(color: Colors.grey.withOpacity(0.5)),
                  ),
                  elevation: 10,
                  shadowColor: Colors.grey.withOpacity(0.2),
                ),
                child: Text(
                  "Kirim",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeInputField(
      TextEditingController controller, FocusNode focusNode) {
    return Container(
      width: 60,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        onChanged: (value) {
          _onChanged(value, focusNode);
        },
      ),
    );
  }

  void _onChanged(String value, FocusNode focusNode) {
    if (value.isNotEmpty) {
      focusNode.nextFocus();
    }
  }
}

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

import 'package:yarytefit/domain/myuser.dart';
import 'package:yarytefit/sevices/auth.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPage();
}

class _AuthPage extends State<AuthPage> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwCtrl = TextEditingController();
  
  String _email = '';
  String _password = '';
  bool showLogin = true;

AuthService _authService = AuthService();

@override
  Widget build(BuildContext context) {

  Widget _logo() {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Container(
        alignment: Alignment.center,
        child: const Text(
          'YARYTЭ Fit',
          style: TextStyle(
              fontSize: 45, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _input(
      Icon icon, String hint, TextEditingController controller, bool obscure) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: TextField(
          controller: controller,
          obscureText: obscure,
          style: const TextStyle(fontSize: 20, color: Colors.white),
          decoration: InputDecoration(
              hintStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white24),
              hintText: hint,
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 3),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white54, width: 1),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: IconTheme(
                    data: const IconThemeData(color: Colors.white),
                    child: icon),
              )
              )
              ),
    );
  }

  Widget _button(String label, void Function() func) {
    return ElevatedButton(
      onPressed: func,
      child: Text(
        label,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor),
      ),
    );
  }

  Widget _form(String label, void Function() func) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 10),
        child: _input(const Icon(Icons.email), 'EMAIL', _emailCtrl, false),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 10),
        child: _input(const Icon(Icons.lock), 'PASSWORD', _passwCtrl, true),
      ),
      const SizedBox(
        height: 20,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: _button(label, func),
        ),
      ),
    ]);
  }

  void _loginButtonLogin() async {
    _email = _emailCtrl.text;
    _password = _passwCtrl.text;

    if(_email.isEmpty || _password.isEmpty) return;

    MyUser? user = await _authService.signInWithEmailAndPassword(_email.trim(), _password.trim());
    if(user == null){
Fluttertoast.showToast(
        msg: "Не возмножно зайти: проверьте email/password",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
    }
    else
    {
    _emailCtrl.clear();
    _passwCtrl.clear();
    }
  }

  void _registerButtonLogin() async {
    _email = _emailCtrl.text;
    _password = _passwCtrl.text;

    if(_email.isEmpty || _password.isEmpty) return;

    MyUser? user = await _authService.registerInWithEmailAndPassword(_email.trim(), _password.trim());
    if(user == null){
Fluttertoast.showToast(
        msg: "Не возмножно зарегистрироваться: проверьте email/password",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
    }
    else
    {
    _emailCtrl.clear();
    _passwCtrl.clear();
    }
  }

  Widget _bottomWave() {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ClipPath(
          clipper: BottomWaveClipper(),
          child: Container(
            color: Colors.cyan,
    height: 300,),
    ),
    )
    );
  }

  return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: <Widget>[
          _logo(),
          const SizedBox(
            height: 100,
          ),
          showLogin
              ? Column(
                  children: [
                    _form('LOGIN', _loginButtonLogin),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                          child: const Text(
                            'Не зарегестрированны? Регистрация!',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          onTap: () {
                            setState(() {
                              showLogin = false;
                            });
                          }),
                    ),
                  ],
                )
              : Column(
                  children: <Widget> [
                    _form('REGISTER', _registerButtonLogin),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                          child: const Text(
                            'Уже зарегестрированы? Логин!',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          onTap: () {
                            setState(() {
                              showLogin = true;
                              });
                            }
                          ),
                        )
                      ],
                ),
              
                _bottomWave(),
        ],
      )
    );
  }

}

class BottomWaveClipper1 extends CustomClipper<Path> {

  @override

  Path getClip(Size size) {

    var path = Path();

    path.lineTo(0.0, size.height - 80);

    path.quadraticBezierTo(

        size.width / 4, size.height - 200, size.width / 2, size.height - 100);

    path.quadraticBezierTo(size.width - (size.width / 4), size.height,

        size.width, size.height - 40);

    path.lineTo(size.width, 0.0);

    path.close();

    return path;

  }

  @override

  bool shouldReclip(CustomClipper<Path> oldClipper) {

    return false;

  }

}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var waveHeight = 50;
    Path path = Path();
    final lowPoint = size.height - waveHeight;
    final highPoint = size.height - waveHeight*2;
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 4, highPoint, size.width / 2, lowPoint);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, lowPoint);
    path.lineTo(size.width, 0);
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
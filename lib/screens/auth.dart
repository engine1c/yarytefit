import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yarytefit/services/auth.dart';

class AuthPage  extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _authorizationPageState createState() => _authorizationPageState();
}

class _authorizationPageState extends State<AuthPage > {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late String _email;
  late String _password;
  bool showLogin = true;

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {

    Widget _logo(){
      return Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Container(
          child: const Align(
            child: Text('yaryte***fit', style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: Colors.white,)
          )
        )
      )
      );
    }

    Widget _input(Icon icon, String hint, TextEditingController controller, bool obscure){
      return Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: TextField(
          controller: controller,
          obscureText: obscure,
          style: const TextStyle(fontSize: 20, color: Colors.white),
          decoration: InputDecoration(
            hintStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white30),
            hintText: hint,
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 3)
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white54, width: 1)
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: IconTheme(
                data: const IconThemeData(color: Colors.white),
                child: icon
              )
            )
          ),
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

    Widget _form(String label, void Function() func){
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 10),
            child: _input(const Icon(Icons.email), "EMAIL", _emailController, false)
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _input(const Icon(Icons.lock), "PASSWORD", _passwordController, true)
          ),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: _button(label, func)
            )
          )
        ],
      );
    }

    void _signInButtonAction() async{      
      _email = _emailController.text;
      _password = _passwordController.text;

      if(_email.isEmpty || _password.isEmpty) return;
      dynamic user = await _authService.signInWithEmailAndPassword(_email.trim(), _password.trim());
      if(user == null) {
        Fluttertoast.showToast(
          msg: "Can't SignIn you! Please check your email/password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        );
      } else{
           _emailController.clear();
          _passwordController.clear();
        }
    }

    void _registerButtonAction() async {
      _email = _emailController.text;
      _password = _passwordController.text;
      
      if(_email.isEmpty || _password.isEmpty) return;

      dynamic user = await _authService.registerInWithEmailAndPassword(_email.trim(), _password.trim());
      if(user == null) {
        Fluttertoast.showToast(
          msg: "Can't Register you! Please check your email/password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        );
      } else{
          _emailController.clear();
          _passwordController.clear();
        }
    }


    Widget _bottomWave() {
      return Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ClipPath(
            clipper: BottomWaveClipper(),
            child: Container(
              color: Colors.white,
              height: 300,
            ),
          ),
        ),
      );
    }    

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: <Widget>[
          _logo(),      
          const SizedBox(height: 100,),    
          (
            showLogin
            ? Column(
              children: <Widget>[
                _form('LOGIN', _signInButtonAction),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    child: const Text('Not registered yet? Register!', style: TextStyle(fontSize: 20, color: Colors.white)),
                    onTap:() {
                      setState((){
                        showLogin = false;
                      });
                    }                   
                  ),
                )
              ],
            )
            : Column(
              children: <Widget>[
                _form('REGISTER', _registerButtonAction),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    child: const Text('Already registered? Login!', style: TextStyle(fontSize: 20, color: Colors.white)),
                    onTap:() {
                      setState((){
                        showLogin = true;
                      });
                    }                   
                  ),
                )
              ],
            )
          ),
          _bottomWave()

        ],
      )
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.lineTo(0.0, size.height + 5);
    var secondControlPoint = Offset(size.width - (size.width / 6), size.height);
    var secondEndPoint = Offset(size.width, 0.0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yarytefit/domain/myuser.dart';
import 'package:yarytefit/screens/auth.dart';
import 'package:yarytefit/screens/home.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MyUser? user = Provider.of<MyUser?>(context);
    final bool isLoggedIn = user != null;

    return isLoggedIn ? HomePage() : const AuthPage();
  }
}
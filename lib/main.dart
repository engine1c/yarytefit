
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yarytefit/core/constants.dart';
import 'package:yarytefit/domain/myuser.dart';

import 'package:yarytefit/screens/landing.dart';
import 'package:yarytefit/services/auth.dart';

// Old Widget 	Old Theme 	New Widget 	New Theme
// FlatButton 	ButtonTheme 	TextButton 	TextButtonTheme
// RaisedButton 	ButtonTheme 	ElevatedButton 	ElevatedButtonTheme
// OutlineButton 	ButtonTheme 	OutlinedButton 	OutlinedButtonTheme

void main() async {
  // start Так себе надувательство :))))
  WidgetsFlutterBinding.ensureInitialized();

  // Включаем только портретную ориентацию
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);

  // Подключаем Firebase для авторизации
  await Firebase.initializeApp();

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseConfig.platformOptions,
  // );
  // Красим статусар в 
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(systemNavigationBarColor: Colors.lightGreen));

  // Выполняем основную программу
  runApp(YaryteFitApp());
}

class YaryteFitApp extends StatelessWidget {
  
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  //YaryteFitApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return const Text('wrong',textDirection: TextDirection.ltr);
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamProvider<MyUser?>.value(
              
              value: AuthService().currentUser,
              initialData: null,
              child: MaterialApp(
                title: 'YARYTЭ Fitness',
                theme: ThemeData(
                  primaryColor: const Color.fromRGBO(50, 65, 85, 1),
                  textTheme: const TextTheme(titleMedium: TextStyle(color: bgWhite)),
                ),
                home: const LandingPage(),
              ),
            );
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return const Text('Loading...',textDirection: TextDirection.ltr);
        });
  }
} 
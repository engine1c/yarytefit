import 'package:firebase_auth/firebase_auth.dart';

class MyUser{
  late String id;
   MyUser.fromFirebase(User? user){
    id = user!.uid;
  }
}
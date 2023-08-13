import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yarytefit/domain/myuser.dart';

// class Users {
//   final String uid;

//   Users({required this.uid});
// }

class AuthService {
  final FirebaseAuth _fAuth = FirebaseAuth.instance;

  // Users? _userFromFirebase(User user) {
  //   if (user == null) {
  //     return null;
  //   }
  //   return Users(uid: user.uid);
  // }

  Future<MyUser?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _fAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return MyUser.fromFirebase(user!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      }
      return null;
    }
  }

  Future<MyUser?> registerInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _fAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return MyUser.fromFirebase(user!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      }
      return null;
    }
  }

  Future logOut() async {
    await _fAuth.signOut();
  }

Stream<MyUser?> get currentUser  {
  //return _fAuth.authStateChanges().map(_userFromFirebase as MyUser Function(User? event));
return _fAuth.authStateChanges().map((User? user) => 
user != null ? MyUser.fromFirebase(user):null);
}
}

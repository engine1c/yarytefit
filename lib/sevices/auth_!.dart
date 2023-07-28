import 'package:firebase_auth/firebase_auth.dart';

// class Users {
//   final String uid;

//   Users({required this.uid});
// }

// abstract class AuthBase {
//   Stream<Users> get authStateChanges;
//   Future<Users> currentUser();
//   Future<Users> signInWithEmailAndPassword(String email, String password);
//   Future<Users> registerInWithEmailAndPassword(String email, String password);
//   Future<void> signOut();
// }

// class AuthService implements AuthBase {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   //To avoid confusion due to updates, "Users" come from the class Users and "User" replaces the deprecated "FirebaseUser".

//   Users? _userFromFirebase(User user) {
//     if (user == null) {
//       return null;
//     }
//     return Users(uid: user.uid);
//   }

//   @override
//   Stream<Users> get authStateChanges {
//     return _firebaseAuth.authStateChanges().map(_userFromFirebase);
//   }

//   @override
//   Future<Users> currentUser() async {
//     final user = _firebaseAuth.currentUser;
//     return _userFromFirebase(user);
//   }


//   @override
//   Future<Users?> signInWithEmailAndPassword(String email, String password) async {
//     final authResult = await _firebaseAuth.signInWithEmailAndPassword(
//         email: email, password: password);
//     return _userFromFirebase(authResult.user);
//   }

//   @override
//   Future<Users?> registerInWithEmailAndPassword(
//       String email, String password) async {
//     final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
//         email: email, password: password);
//     return _userFromFirebase(authResult.user);
//   }

//   @override
//   Future<void> signOut() async {
//     await _firebaseAuth.signOut();
//   }
// }
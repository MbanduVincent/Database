import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthentication {
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<String> createUser(String email, String password) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user!.uid;
    } on FirebaseAuthException {
// print(au)
      return 'Error occurred';
    }
  }

  Future<String> loginUser(String email, String password) async {
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user!.uid;
    } on FirebaseAuthException {
// print(au)
      return 'Error occurred';
    }
  }

  Future<bool> logout() async {
    try {
      auth.signOut();
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }
}

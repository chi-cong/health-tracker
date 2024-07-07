import 'package:firebase_auth/firebase_auth.dart';
import './auth_err_mapper.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createUser(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw mapSignupErrors(e.code);
    } catch (e) {
      throw 'Something went wrong. Please try again (ᗒᗣᗕ)՞';
    }
  }

  Future<UserCredential?> loggin(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential;
    } on FirebaseAuthException catch (e) {
      throw mapLogginErrors(e.code);
    } catch (e) {
      throw 'Something went wrong. Please try again (ᗒᗣᗕ)՞';
    }
  }

  User? getCurrUser() {
    return _auth.currentUser;
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw 'Something went wrong. Please try again (ᗒᗣᗕ)՞';
    }
  }

  void logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'Something went wrong. Please try again (ᗒᗣᗕ)՞';
    }
  }
}

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<FirebaseUser> signIn(String email, String password);

  Future<FirebaseUser> signUp(String email, String password, String username);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<void> sendPasswordResetEmail(String email);
}

class FirebaseAuthentication implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String errorMessage = "";

  static FirebaseUser currentUser;

  Future<FirebaseUser> signIn(String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser user = result.user;
      errorMessage = "";
      return user;
    }catch(exception) {
      errorMessage = exception.toString();
      return null;
    }
  }

  Future<FirebaseUser> signInWithCredential(AuthCredential credential) async {
    AuthResult result = await _firebaseAuth.signInWithCredential(credential);
    return result.user;
  }

  Future<FirebaseUser> signUp(String email, String password, String ffLogUsername) async {
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      UserUpdateInfo info = new UserUpdateInfo();
      info.displayName = ffLogUsername;
      await user.updateProfile(info);
      await user.reload();

      user = await _firebaseAuth.currentUser();

      print(user.displayName);

      return user;
    }catch(exception) {
      return null;
    }
  }

  Future<FirebaseUser> getCurrentUser() async {
    currentUser = await _firebaseAuth.currentUser();
    return currentUser;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
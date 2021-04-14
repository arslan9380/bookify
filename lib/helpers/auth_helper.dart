import 'package:bookify/models/user.dart';
import 'package:bookify/utils/constants.dart';
import 'package:bookify/utils/static_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthStatus {
  static const String ERROR_WEAK_PASSWORD = 'weak-password';
  static const String ERROR_INVALID_EMAIL = 'invalid-email';
  static const String ERROR_EMAIL_ALREADY_IN_USE = 'email-already-in-use';
  static const String ERROR_WRONG_PASSWORD = 'ERROR_WRONG_PASSWORD';
  static const String ERROR_USER_NOT_FOUND = 'user-not-found';
}

class AuthHelper {
  final _usersKey = 'users';

  Future<String> signUp(UserModel user, String password) async {
    try {
      var authResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: user.email, password: password);
      user.uid = authResult.user.uid;
      var saveResult = await saveUser(user);
      if (saveResult != Constants.success) return saveResult;
      StaticInfo.user = user;
      return Constants.success;
    } catch (error) {
      print("error in SigningUp the user : ${error.code}");
      return "${error.code}";
    }
  }

  Future<String> login(String email, String password) async {
    try {
      var authResult = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      await getUser(authResult.user.uid);
      return Constants.success;
    } catch (error) {
      print("Error in logging the user : $error//////");

      return "${error?.code}";
    }
  }

  Future<dynamic> getCurrentUser() async {
    var result = FirebaseAuth.instance.currentUser;
    var responseToBerReturned;
    if (result == null) {
      responseToBerReturned = false;
    } else {
      var response = await getUser(result.uid);
      if (response != null) {
        responseToBerReturned = true;
      } else {
        responseToBerReturned = false;
      }
    }
    return responseToBerReturned;
  }

  Future<String> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      return Constants.success;
    } catch (e) {
      return e.code;
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    StaticInfo.user = null;
  }

  Future<String> saveUser(UserModel user) async {
    try {
      await FirebaseFirestore.instance
          .collection(_usersKey)
          .doc(user.uid)
          .set(user.toMap(), SetOptions(merge: true));

      return Constants.success;
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> getUser(String uid) async {
    try {
      var responseToBeReturned;
      StaticInfo.user = UserModel.fromMap((await FirebaseFirestore.instance
              .collection(_usersKey)
              .doc(uid)
              .get())
          .data());
      if (StaticInfo.user.accountType == Constants.user) {
      } else if (StaticInfo.user.accountType == Constants.owner) {
      } else if (StaticInfo.user.accountType == Constants.admin) {}
      return responseToBeReturned;
    } catch (e) {
      print("Error in assigning static info :$e");
      return e;
    }
  }
}

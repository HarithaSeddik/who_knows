import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:who_knows/models/whoknows_userdb.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  UserRepository({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<String> signInWithCredentials(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    if (_firebaseAuth.currentUser.emailVerified) {
      WhoKnowsUserDB user = WhoKnowsUserDB();
      await user.setValue("isOnline", true);
      await user.setValue("lastSeen", DateTime.now().toUtc().toString());
      return _firebaseAuth.currentUser.uid;
    }
    return null;
  }

  Future<void> signUp(String email, String password) async {
    UserCredential uc = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    try {
      await _firebaseAuth.currentUser.sendEmailVerification();
      WhoKnowsUserDB user = WhoKnowsUserDB();
      user.registerUser(email);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String name = prefs.getString("name");
      FirebaseAuth.instance.currentUser.updateProfile(displayName:name, photoURL: '');
      return _firebaseAuth.currentUser.uid;
    } catch (e) {
      print("An error occured while trying to send email verification");
      print(e.message);
    }
    return uc;
  }

  Future<void> signOut() async {
    WhoKnowsUserDB user = WhoKnowsUserDB();
    await user.setValue("isOnline", false);
    await user.setValue("lastSeen", DateTime.now().toUtc().toString());
    return Future.wait([_firebaseAuth.signOut()]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<User> getUser() async {
    return _firebaseAuth.currentUser;
  }
}

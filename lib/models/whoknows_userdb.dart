import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WhoKnowsUserDB {
  // create user in firestore
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('users');

  Future<void> registerUser(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Call the user's CollectionReference to add a new user
    return collectionReference.doc(FirebaseAuth.instance.currentUser.uid).set({
      'name': prefs.getString("name"),
      'username': prefs.getString("username"),
      'email': email,
      'wantNotifications': false,
      'rating': 0,
      'profilePic':'',
      'lastSeen':'',
    }).then((value) {
      print("User Added");
      prefs.remove("name");
      prefs.remove("username");
    }).catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> setValue(String key, dynamic value) {
    // Call the user's CollectionReference to add a new user
    return collectionReference
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({key: value})
        .then((val) => print("$key: $value"))
        .catchError((error) => print("Failed to set value: $error"));
  }

  Future<Map<String, dynamic>> getDocData({String username}) async {
    String id;
    if (username != null) {
      id =  await getId(username);
    }

    DocumentSnapshot documentSnapshot = await collectionReference
        .doc(id ?? FirebaseAuth.instance.currentUser.uid)
        .get();
    // print(documentSnapshot.data());
    return documentSnapshot.data();
  }

  Future<bool> usernameCheck(String username) async {
    final result =
        await collectionReference.where('username', isEqualTo: username).get();
    return result.docs.isEmpty;
  }

  Future<String> getId(String username) async {
    final result =
        await collectionReference.where('username', isEqualTo: username).get();
    return result.docs[0].id;
  }

  Future<List<Map<String, dynamic>>> getTopUsers() async {
    List<Map<String, dynamic>> topUsers = [];
    QuerySnapshot qShot =
        await collectionReference.orderBy('rating', descending: true).limit(10).get();
    for (int i = 0; i < qShot.docs.length; i++) {
      topUsers.add(qShot.docs[i].data());
    }
    return topUsers;
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    List<Map<String, dynamic>> allUsers = [];
    QuerySnapshot qShot =
        await collectionReference.orderBy('rating', descending: true).get();
    for (int i = 0; i < qShot.docs.length; i++) {
      allUsers.add(qShot.docs[i].data());
    }
    return allUsers;
  }

  Future<List<Map<String, dynamic>>> getSearchUsers() async {
    List<Map<String, dynamic>> searchUsers = [];
    QuerySnapshot qShot =
        await collectionReference.orderBy('username').get();
    for (int i = 0; i < qShot.docs.length; i++) {
      searchUsers.add(qShot.docs[i].data());
    }
    return searchUsers;
  }

}

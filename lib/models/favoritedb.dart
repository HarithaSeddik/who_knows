import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:who_knows/models/whoknows_userdb.dart';

class FavoriteDB {
  WhoKnowsUserDB whoKnowsUserDB = WhoKnowsUserDB();

  Future<void> addFavorite(
      String uidToAdd, String username) async {

    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('favorites')
        .doc(uidToAdd);

    return documentReference.set(
        {'username':username}).then((value) {
    }).catchError((error) => print("Failed to add review: $error"));
  }
  

  Future<void> removeFavorite(
      String uidToDelete) async {

    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('favorites')
        .doc(uidToDelete);

    return documentReference.delete().then((value) {
      print("Favorite Deleted");
    }).catchError((error) => print("Failed to add review: $error"));
  }

  Future<bool> isInFavorites(String username) async{
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('favorites');
    final result =
        await collectionReference.where('username', isEqualTo: username).get();
    return result.docs.isNotEmpty;
  }



  Future<List<Map<String, dynamic>>> getAllFavorites() async {
    List<Map<String, dynamic>> favorites = [];

    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('favorites');

    QuerySnapshot qShot = await collectionReference.get();
    for (int i = 0; i < qShot.docs.length; i++) {
      Map<String, dynamic> user = await whoKnowsUserDB.getDocData(username: qShot.docs[i].data()['username']);
      favorites.add(user);
    }
    return favorites;
  }
}

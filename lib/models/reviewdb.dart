import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:who_knows/models/whoknows_userdb.dart';

class ReviewDB {
  WhoKnowsUserDB whoKnowsUserDB = WhoKnowsUserDB();

  Future<void> createReview(
      String username, String content, double rating, String topicTitle) async {
    String uid = await whoKnowsUserDB.getId(username);

    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('topics')
        .doc(topicTitle)
        .collection('reviews')
        .doc();

    String byName = (await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .get())
        .data()['username'];

    return documentReference.set(
        {'byName': byName, 'content': content, 'rating': rating}).then((value) {
      print("Review Added");
    }).catchError((error) => print("Failed to add review: $error"));
  }

  Future<List<Map<String, dynamic>>> getAllReviews(String topicTitle,
      {String username}) async {
    String id;
    if (username != null) {
      id = await whoKnowsUserDB.getId(username);
    }

    List<Map<String, dynamic>> reviews = [];

    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('users')
        .doc(id ?? FirebaseAuth.instance.currentUser.uid)
        .collection('topics')
        .doc(topicTitle)
        .collection('reviews');

    QuerySnapshot qShot = await collectionReference.get();
    for (int i = 0; i < qShot.docs.length; i++) {
      reviews.add(qShot.docs[i].data());
    }
    return reviews;
  }
}

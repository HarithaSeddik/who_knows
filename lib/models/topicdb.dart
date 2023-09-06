import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:who_knows/models/whoknows_userdb.dart';

class TopicDB {
  // create topics db in firestore
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('users');
  WhoKnowsUserDB whoKnowsUserDB = WhoKnowsUserDB();

  Future<void> createTopic(String title, String tier) async {
    // Call the user's CollectionReference to add a new user
    return collectionReference
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('topics')
        .doc(title)
        .set({
      'title': title,
      'star': tier,
      'desc': '',
      'audioURL': '',
      'videoURL': '',
      'isCallActive': false,
      'isVideoActive': false,
      'rating': 1,
      'price': tier == 'Free' ? 0 : 1,
      'points': 0,
    }).then((value) {
      print("Topic Added");
    }).catchError((error) => print("Failed to add topic: $error"));
  }

  Future<void> setValue(String title, String key, dynamic value) async {
    // Call the user's CollectionReference to add a new user
    return collectionReference
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('topics')
        .doc(title)
        .update({
      key: value,
      'price': (await getValue(title, 'star')) == 'Free'
          ? 0
          : ((await getValue(title, "rating")) > 4 &&
                  (await getValue(title, "rating")) < 5)
              ? 2
              : 5,
    }).then((value) {
      print("$key Added");
    }).catchError((error) => print("Failed to add description: $error"));
  }

  Future<bool> titleCheck(String title) async {
    final result = await collectionReference
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('topics')
        .doc(title)
        .get();
    return result.exists;
  }

  Future<List<Map<String, dynamic>>> getAllTopicsPerUser(
      {String username}) async {
    String id;
    if (username != null) {
      id = await whoKnowsUserDB.getId(username);
    }

    List<Map<String, dynamic>> topics = [];
    QuerySnapshot qShot = await collectionReference
        .doc(id ?? FirebaseAuth.instance.currentUser.uid)
        .collection('topics')
        .get();
    for (int i = 0; i < qShot.docs.length; i++) {
      topics.add(qShot.docs[i].data());
    }
    return topics;
  }

  Future<Map<String, List<Map<String, dynamic>>>> getAllTopics() async {
    List<Map<String, dynamic>> users = await whoKnowsUserDB.getAllUsers();
    Map<String, List<Map<String, dynamic>>> topics = Map();

    for (var user in users) {
      String id = await whoKnowsUserDB.getId(user['username']);
      List<Map<String, dynamic>> tempList = [];
      QuerySnapshot qShot =
          await collectionReference.doc(id).collection('topics').get();
      for (int i = 0; i < qShot.docs.length; i++) {
        Map<String, dynamic> topicData = qShot.docs[i].data();
        topicData['gender'] = user["gender"];
        topicData['country'] = user["country"];
        topicData['isOnline'] = user["isOnline"];
        tempList.add(topicData);
      }
      topics[user['username']] = tempList;
    }
    return topics;
  }

  Future<dynamic> getValue(String title, String key, {String username}) async {
    String id;
    if (username != null) {
      id = await whoKnowsUserDB.getId(username);
    }
    final result = await collectionReference
        .doc(id ?? FirebaseAuth.instance.currentUser.uid)
        .collection('topics')
        .doc(title)
        .get();
    return result.data()[key];
  }

  Future<void> deleteTopic(String title, {String username}) async {
    String id;
    if (username != null) {
      id = await whoKnowsUserDB.getId(username);
    }

    final reviews = await collectionReference
        .doc(id ?? FirebaseAuth.instance.currentUser.uid)
        .collection('topics')
        .doc(title)
        .collection('reviews')
        .get();
        
    for (DocumentSnapshot ds in reviews.docs) {
      ds.reference.delete();
    }

    final result = await collectionReference
        .doc(id ?? FirebaseAuth.instance.currentUser.uid)
        .collection('topics')
        .doc(title)
        .delete();
    return result;
  }
}

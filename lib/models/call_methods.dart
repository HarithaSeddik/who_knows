import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:who_knows/repos/call.dart';

class CallMethods {
  final CollectionReference callCollection =
      FirebaseFirestore.instance.collection("calls");

  Stream<DocumentSnapshot> callStream({String uid}) {
    return callCollection.doc(uid).snapshots();
  }

  Future<bool> makeCall({Call call}) async {
    try {
      call.hasDialled = true;
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      call.hasDialled = false;
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      await callCollection.doc(call.callerId).set(hasDialledMap);
      await callCollection.doc(call.receiverId).set(hasNotDialledMap);
      
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Future<bool> endCall({Call call}) async{
  //   try{
  //     await callCollection.doc(call.callerId).delete();
  //     await callCollection.doc(call.receiverId).delete();
  //     return true;
  //   } catch(e){
  //     print(e);
  //     return false;
  //   }
  // }

  Future<bool> endCall({Call call}) async {
    try {
      CollectionReference callCollection =
          FirebaseFirestore.instance.collection("calls");
      await callCollection.doc(call.receiverId).delete();
      await callCollection.doc(call.callerId).update({'has_ended': 'caller'});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

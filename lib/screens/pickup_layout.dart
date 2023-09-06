import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:who_knows/models/call_methods.dart';
import 'package:who_knows/repos/call.dart';
import 'package:who_knows/screens/pickup_screen.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';


class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallMethods callMethods = CallMethods();
  
  PickupLayout({Key key, @required this.scaffold}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: callMethods.callStream(uid: FirebaseAuth.instance.currentUser.uid),
      builder: (context, snapshot){

        if (snapshot.hasData && snapshot.data.data() != null && snapshot.data.data()['caller_id'] != FirebaseAuth.instance.currentUser.uid){
            Call call = Call.fromMap(snapshot.data.data());
            return PickupScreen(call: call);
        }
        else{
          FlutterRingtonePlayer.stop();
          return scaffold;
        }
      },
    );
  }
}
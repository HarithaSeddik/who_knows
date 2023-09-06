import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:who_knows/models/call_methods.dart';
import 'package:who_knows/models/whoknows_userdb.dart';
import 'package:who_knows/repos/call.dart';
import 'package:who_knows/screens/call_screen.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';


class CallUtils {
  WhoKnowsUserDB whoKnowsUserDB = WhoKnowsUserDB();
  static final CallMethods callMethods = CallMethods();

  void dial(
      {String callerUsername,
      String receiverUsername,
      String title,
      bool isVideo,
      BuildContext context}) async {
    // Caller
    String callerId = await whoKnowsUserDB.getId(callerUsername);
    Map<String, dynamic> caller =
        await whoKnowsUserDB.getDocData(username: callerUsername);

    // Receiver
    String receiverId = await whoKnowsUserDB.getId(receiverUsername);
    Map<String, dynamic> receiver =
        await whoKnowsUserDB.getDocData(username: receiverUsername);

    // call object
    Call call = Call(
      callerId: callerId,
      callerName: caller['name'],
      callerPic: caller['profilePic'],
      receiverUsername: receiverUsername,
      receiverId: receiverId,
      receiverName: receiver['name'],
      receiverPic: receiver['profilePic'],
      channelId: Random().nextInt(1000).toString(),
      callTopic: title,
      isVideo: isVideo,
      hasEnded: 'none',
    );

    bool callMade = await callMethods.makeCall(call: call);
    call.hasDialled = true;
    
    if (callMade) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CallScreen(call: call)));
    }
    else{
      FlutterRingtonePlayer.stop();
    }
  }
}

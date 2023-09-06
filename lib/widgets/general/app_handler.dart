import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:who_knows/models/whoknows_userdb.dart';

class AppHandler extends WidgetsBindingObserver {
  AudioPlayer audioPlayer;
  AppHandler(AudioPlayer _audioPlayer){
    this.audioPlayer = _audioPlayer;
  }

  @override
  void didChangeAppLifecycleState(
    AppLifecycleState state,
  ) {
    if (state == AppLifecycleState.resumed) {
      changeStatus(true);
    } else {
      changeStatus(false);
      if (audioPlayer != null) {
        audioPlayer.stop();
      }
    }
  }

  void changeStatus(bool status) async {
    WhoKnowsUserDB user = WhoKnowsUserDB();
    await user.setValue("isOnline", status);
    await user.setValue("lastSeen", DateTime.now().toUtc().toString());
  }
}

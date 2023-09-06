import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:who_knows/models/call_methods.dart';
import 'package:who_knows/repos/call.dart';
import 'package:who_knows/screens/call_screen.dart';
import 'package:who_knows/utils/permissions.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class PickupScreen extends StatefulWidget {
  final Call call;

  PickupScreen({Key key, @required this.call}) : super(key: key);

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final CallMethods callMethods = CallMethods();

  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    FlutterRingtonePlayer.play(
      android: AndroidSounds.notification,
      ios: IosSounds.glass,
      looping: true,
      volume: 1.0,
    );
  }

  @override
  void didUpdateWidget(PickupScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Incoming..."),
            SizedBox(height: 50),
            CircleAvatar(
              radius: 70,
              backgroundImage: NetworkImage(widget.call.callerPic),
            ),
            SizedBox(height: 15),
            Text(
              widget.call.callerName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 75),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.call_end),
                  color: Colors.redAccent,
                  onPressed: () async {
                    FlutterRingtonePlayer.stop();
                    await callMethods.endCall(call: widget.call);
                  },
                ),
                SizedBox(width: 25),
                IconButton(
                  icon: Icon(Icons.call),
                  color: Colors.green,
                  onPressed: () async {
                    FlutterRingtonePlayer.stop();
                    bool permissions = await Permissions
                        .cameraAndMicrophonePermissionsGranted();
                    if (permissions == true) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CallScreen(call: widget.call),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

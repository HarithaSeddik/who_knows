import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:who_knows/config/constants.dart';
import 'package:who_knows/models/reviewdb.dart';
import 'package:who_knows/models/topicdb.dart';
import 'package:who_knows/models/whoknows_userdb.dart';
import 'package:who_knows/utils/call_utils.dart';
import 'package:who_knows/utils/permissions.dart';
import 'package:who_knows/widgets/general/review.dart';
import 'package:who_knows/widgets/general/app_handler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:better_player/better_player.dart';

class StatsTopics extends StatefulWidget {
  final String title;
  final String username;
  final FocusNode focusIntro;
  final bool isCallActive;
  final bool isVideoActive;

  const StatsTopics({
    Key key,
    this.title,
    @required this.focusIntro,
    @required this.isCallActive,
    @required this.isVideoActive,
    @required this.username,
  }) : super(key: key);

  @override
  _StatsTopicsState createState() => _StatsTopicsState();
}

class _StatsTopicsState extends State<StatsTopics> {
  final TextEditingController introController = TextEditingController();
  WhoKnowsUserDB whoKnowsUserDB = WhoKnowsUserDB();
  TopicDB topicDB = TopicDB();
  ReviewDB reviewDB = ReviewDB();
  List<Map<String, dynamic>> _reviews;
  AudioPlayer _player = AudioPlayer();
  bool _isCallActive;
  bool _isVideoActive;
  bool sourceStatus = false;
  String _audioUrl = '';
  String _videoUrl = '';
  bool audioLoaderFlag = false;
  bool videoLoaderFlag = false;
  BetterPlayerController _betterPlayerController;
  BetterPlayerDataSource _betterPlayerDataSource;

  Future<void> initializeAudio() async {
    setState(() {
      audioLoaderFlag = true;
    });
    String url = await topicDB.getValue(widget.title, 'audioURL', username: widget.username);
    setState(() {
      _audioUrl = url ?? '';
      _player.load(
        AudioSource.uri(
          Uri.parse(url),
        ),
      );
      audioLoaderFlag = false;
    });
  }

  Future<void> initializePlayer() async {
    setState(() {
      videoLoaderFlag = true;
    });
    String url = await topicDB.getValue(widget.title, "videoURL", username: widget.username);
    print("X: $url -- $_videoUrl");
    if (url != "") {
      setState(() {
        _videoUrl = url;
        _betterPlayerDataSource =
            BetterPlayerDataSource(BetterPlayerDataSourceType.network, url);

        // Initing new controller
        _betterPlayerController = BetterPlayerController(
            BetterPlayerConfiguration(autoDispose: false, aspectRatio: 3 / 2),
            betterPlayerDataSource: _betterPlayerDataSource);
        videoLoaderFlag = false;
      });
    } else {
      setState(() {
        _videoUrl = url;
        videoLoaderFlag = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _isCallActive = widget.isCallActive;
    _isVideoActive = widget.isVideoActive;
    WidgetsBinding.instance.addObserver(new AppHandler(_player));
    whoKnowsUserDB.getDocData(username: widget.username).then((value) {
      setState(() {
        sourceStatus = value['isOnline'];
      });
    });

    reviewDB
        .getAllReviews(widget.title, username: widget.username)
        .then((value) {
      setState(() {
        _reviews = value;
      });
    });

    topicDB
        .getValue(widget.title, "desc", username: widget.username)
        .then((value) {
      setState(() {
        introController.text = value;
      });
    });
    initializeAudio();
    initializePlayer();
  }

  @override
  void didUpdateWidget(StatsTopics oldWidget) {
    super.didUpdateWidget(oldWidget);
    whoKnowsUserDB.getDocData(username: widget.username).then((value) {
      setState(() {
        sourceStatus = value['isOnline'];
      });
    });

    topicDB
        .getValue(widget.title, "isCallActive", username: widget.username)
        .then((value) {
      setState(() {
        _isCallActive = value;
      });
    });
    topicDB
        .getValue(widget.title, "isVideoActive", username: widget.username)
        .then((value) {
      setState(() {
        _isVideoActive = value;
      });
    });
    reviewDB
        .getAllReviews(widget.title, username: widget.username)
        .then((value) {
      setState(() {
        _reviews = value;
      });
    });

    topicDB
        .getValue(widget.title, "desc", username: widget.username)
        .then((value) {
      setState(() {
        introController.text = value;
      });
    });

    initializeAudio();
    initializePlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () async {
                Map<String, dynamic> map =
                    await whoKnowsUserDB.getDocData(username: widget.username);
                bool status = map['isOnline'];
                setState(() {
                  sourceStatus = status;
                });
                if (_isCallActive && status == true) {
                  CallUtils callUtils = CallUtils();
                  Map<String, dynamic> caller =
                      await whoKnowsUserDB.getDocData();
                  if (caller['username'] != widget.username) {
                    bool granted = await Permissions
                        .cameraAndMicrophonePermissionsGranted();
                    if (granted)
                      callUtils.dial(
                        callerUsername: caller['username'],
                        receiverUsername: widget.username,
                        title: widget.title,
                        isVideo: false,
                        context: context,
                      );
                  }
                }
              },
              child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[500],
                        blurRadius: 1.0, // soften the shadow
                        spreadRadius: 0.5, //extend the shadow
                        offset: Offset(
                          2.0, // Move to right 10  horizontally
                          1.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                    border: Border.all(
                        color: (_isCallActive && sourceStatus == true)
                            ? Colors.white
                            : (_isCallActive
                                ? Colors.white
                                : Colors.lightGreenAccent[400]),
                        width: 2),
                    shape: BoxShape.circle,
                    color: (_isCallActive && sourceStatus == true)
                        ? Colors.lightGreenAccent[400]
                        : (_isCallActive ? Colors.grey : Colors.white),
                  ),
                  child: Icon(Icons.call,
                      color: (_isCallActive && sourceStatus == true)
                          ? Colors.white
                          : (_isCallActive
                              ? Colors.white
                              : Colors.lightGreenAccent[400]),
                      size: 30)),
            ),
            GestureDetector(
              onTap: () async {
                Map<String, dynamic> map =
                    await whoKnowsUserDB.getDocData(username: widget.username);
                bool status = map['isOnline'];
                setState(() {
                  sourceStatus = status;
                });
                if (_isVideoActive && status == true) {
                  CallUtils callUtils = CallUtils();
                  Map<String, dynamic> caller =
                      await whoKnowsUserDB.getDocData();
                  if (caller['username'] != widget.username) {
                    bool granted = await Permissions
                        .cameraAndMicrophonePermissionsGranted();
                    if (granted)
                      callUtils.dial(
                          callerUsername: caller['username'],
                          receiverUsername: widget.username,
                          title: widget.title,
                          isVideo: true,
                          context: context);
                  }
                }
              },
              child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[500],
                        blurRadius: 1.0, // soften the shadow
                        spreadRadius: 0.5, //extend the shadow
                        offset: Offset(
                          2.0, // Move to right 10  horizontally
                          1.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                    border: Border.all(
                        color: (_isVideoActive && sourceStatus == true)
                            ? Colors.white
                            : (_isVideoActive
                                ? Colors.white
                                : Colors.lightGreenAccent[400]),
                        width: 2),
                    shape: BoxShape.circle,
                    color: (_isVideoActive && sourceStatus == true)
                        ? Colors.lightGreenAccent[400]
                        : (_isVideoActive ? Colors.grey : Colors.white),
                  ),
                  child: Icon(Icons.video_call,
                      color: (_isVideoActive && sourceStatus == true)
                          ? Colors.white
                          : (_isVideoActive
                              ? Colors.white
                              : Colors.lightGreenAccent[400]),
                      size: 30)),
            ),
            Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[500],
                        blurRadius: 1.0, // soften the shadow
                        spreadRadius: 0.5, //extend the shadow
                        offset: Offset(
                          2.0, // Move to right 10  horizontally
                          1.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                    border: Border.all(
                        color: sourceStatus
                            ? Colors.lightGreenAccent[400]
                            : Colors.white,
                        width: 2),
                    shape: BoxShape.circle,
                    color: sourceStatus ? Colors.white : Colors.grey),
                child: Icon(Icons.message,
                    color: sourceStatus
                        ? Colors.lightGreenAccent[400]
                        : Colors.white,
                    size: 30)),
          ],
        ),
        SizedBox(height: 20),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: RichText(
            text: TextSpan(
              text: "Introduction Message\n",
              style: TextStyle(
                fontSize: appAltTitleSize,
                color: appTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        TextFormField(
          maxLines: 5,
          readOnly: true,
          controller: introController,
          decoration: new InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            labelText: "Topic Introducion Message",
            fillColor: Colors.white,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: new BorderSide(),
            ),
          ),
          validator: (val) {
            return null;
          },
          keyboardType: TextInputType.text,
          focusNode: widget.focusIntro,
        ),
        SizedBox(height: 30),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: RichText(
            text: TextSpan(
              text: "Audio\n",
              style: TextStyle(
                fontSize: appAltTitleSize,
                color: appTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        (_audioUrl != '' && !audioLoaderFlag)
            ? Center(child: ControlButtons(_player))
            : Center(child: Text("Audio does not exist")),
        if (audioLoaderFlag)
          SpinKitFadingCircle(
            color: appTheme,
            size: 50.0,
          ),
        SizedBox(height: 20),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: RichText(
            text: TextSpan(
              text: "Video\n",
              style: TextStyle(
                fontSize: appAltTitleSize,
                color: appTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        (_videoUrl != "" && _betterPlayerController != null) ?
          AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer(
              controller: _betterPlayerController,
            ),
          ) : Center(child: Text("Video does not exist")),
        if (_videoUrl != "" && _betterPlayerController != null)
          SizedBox(height: 5),
        if (videoLoaderFlag)
          SpinKitFadingCircle(
            color: appTheme,
            size: 50.0,
          ),
        if (videoLoaderFlag) SizedBox(height: 5),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: RichText(
            text: TextSpan(
              text: "Reviews\n",
              style: TextStyle(
                fontSize: appAltTitleSize,
                color: appTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Column(
          children: [
            if (_reviews != null)
              for (var e in _reviews)
                Review(
                  byUsername: e['byName'],
                  rating: e['rating'],
                  content: e['content'],
                ),
          ],
        ),
      ]),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  ControlButtons(this.player);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.volume_up),
          onPressed: () {
            _showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),
        StreamBuilder<SequenceState>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: Icon(Icons.skip_previous),
            onPressed: player.hasPrevious ? player.seekToPrevious : null,
          ),
        ),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: Icon(Icons.play_arrow),
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: Icon(Icons.pause),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: Icon(Icons.replay),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero, index: 0),
              );
            }
          },
        ),
        StreamBuilder<SequenceState>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: Icon(Icons.skip_next),
            onPressed: player.hasNext ? player.seekToNext : null,
          ),
        ),
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              _showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}

_showSliderDialog({
  BuildContext context,
  String title,
  int divisions,
  double min,
  double max,
  String valueSuffix = '',
  Stream<double> stream,
  ValueChanged<double> onChanged,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => Container(
          height: 100.0,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: TextStyle(
                      fontFamily: 'Fixed',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0)),
              Slider(
                divisions: divisions,
                min: min,
                max: max,
                value: snapshot.data ?? 1.0,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

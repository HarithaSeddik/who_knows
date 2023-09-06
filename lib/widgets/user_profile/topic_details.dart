import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:who_knows/config/constants.dart';
import 'package:who_knows/models/reviewdb.dart';
import 'package:who_knows/models/topicdb.dart';
import 'package:who_knows/widgets/bottom_nav.dart';
import 'package:who_knows/widgets/general/app_handler.dart';
import 'package:who_knows/widgets/general/ink_card.dart';
import 'package:who_knows/widgets/login/login_button.dart';
import 'package:who_knows/widgets/general/review.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:better_player/better_player.dart';
import 'package:toast/toast.dart';
import 'package:path/path.dart' as p;

class TopicDetails extends StatefulWidget {
  final String title;

  final FocusNode focusIntro;
  final bool isCallActive;
  final bool isVideoActive;

  const TopicDetails({
    Key key,
    this.title,
    @required this.focusIntro,
    @required this.isCallActive,
    @required this.isVideoActive,
  }) : super(key: key);

  @override
  _TopicDetailsState createState() => _TopicDetailsState();
}

class _TopicDetailsState extends State<TopicDetails> {
  final TextEditingController introController = TextEditingController();
  TopicDB topicDB = TopicDB();
  ReviewDB reviewDB = ReviewDB();
  List<Map<String, dynamic>> _reviews;
  AudioPlayer _player = AudioPlayer();
  BetterPlayerController _betterPlayerController;
  BetterPlayerDataSource _betterPlayerDataSource;

  bool _isCallActive;
  bool _isVideoActive;
  String _uploadedFileURL;
  String _audioUrl = '';
  String _videoUrl = '';
  bool audioLoaderFlag = false;
  bool videoLoaderFlag = false;

  Future<void> initializeAudio() async {
    setState(() {
      audioLoaderFlag = true;
    });
    String url = await topicDB.getValue(widget.title, 'audioURL');
    setState(() {
      audioLoaderFlag = true;
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
    String url = await topicDB.getValue(widget.title, "videoURL");
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

    reviewDB.getAllReviews(widget.title).then((value) {
      setState(() {
        _reviews = value;
      });
    });

    topicDB.getValue(widget.title, "desc").then((value) {
      setState(() {
        introController.text = value;
      });
    });

    initializeAudio();
    initializePlayer();
  }

  @override
  void didUpdateWidget(TopicDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    topicDB.getValue(widget.title, "isCallActive").then((value) {
      setState(() {
        _isCallActive = value;
      });
    });
    topicDB.getValue(widget.title, "isVideoActive").then((value) {
      setState(() {
        _isVideoActive = value;
      });
    });
    reviewDB.getAllReviews(widget.title).then((value) {
      setState(() {
        _reviews = value;
      });
    });

    topicDB.getValue(widget.title, "desc").then((value) {
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
                bool curVal =
                    await topicDB.getValue(widget.title, "isCallActive");
                await topicDB.setValue(widget.title, "isCallActive", !curVal);
                setState(() {
                  _isCallActive = !_isCallActive;
                });
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
                          color: _isCallActive
                              ? Colors.white
                              : Colors.lightGreenAccent[400],
                          width: 2),
                      shape: BoxShape.circle,
                      color: _isCallActive
                          ? Colors.lightGreenAccent[400]
                          : Colors.white),
                  child: Icon(Icons.call,
                      color: _isCallActive
                          ? Colors.white
                          : Colors.lightGreenAccent[400],
                      size: 30)),
            ),
            GestureDetector(
              onTap: () async {
                bool curVal =
                    await topicDB.getValue(widget.title, "isVideoActive");
                await topicDB.setValue(widget.title, "isVideoActive", !curVal);
                setState(() {
                  _isVideoActive = !_isVideoActive;
                });
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
                          color: _isVideoActive
                              ? Colors.white
                              : Colors.lightGreenAccent[400],
                          width: 2),
                      shape: BoxShape.circle,
                      color: _isVideoActive
                          ? Colors.lightGreenAccent[400]
                          : Colors.white),
                  child: Icon(Icons.video_call,
                      color: _isVideoActive
                          ? Colors.white
                          : Colors.lightGreenAccent[400],
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
                        color: Colors.lightGreenAccent[400], width: 2),
                    shape: BoxShape.circle,
                    color: Colors.white),
                child: Icon(Icons.message,
                    color: Colors.lightGreenAccent[400], size: 30)),
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
        SizedBox(height: 10),
        LoginButton(
          width: 350,
          height: 45,
          onPressed: () async {
            await topicDB.setValue(widget.title, "desc", introController.text);
            setState(() {});
            Toast.show("Intro Updated", context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          },
          text: "Update Message",
          icon: Icon(
            Icons.arrow_right,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20),
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
        (_audioUrl != '' && audioLoaderFlag == false)
            ? Center(child: ControlButtons(_player))
            : Center(child: Text("Audio could not be loaded")),
        if (audioLoaderFlag)
          SpinKitFadingCircle(
            color: appTheme,
            size: 50.0,
          ),
        if (audioLoaderFlag) SizedBox(height: 5),
        InkCard(
            title: _audioUrl != '' ? "Update your audio" : "Upload your audio",
            press: () async {
              var file = await FilePicker.getFile(type: FileType.audio);
              var fileName = p.basename(file.path);
              if (fileName != '') {
                if (_audioUrl != '') {
                  String delUrl =
                      await topicDB.getValue(widget.title, 'audioURL');
                  FirebaseStorage.instance
                      .getReferenceFromUrl(delUrl)
                      .then((res) {
                    res.delete().then((res) {
                      print("Deleted!");
                    });
                  });
                }

                setState(() {
                  audioLoaderFlag = true;
                });
                StorageReference storageReference = FirebaseStorage.instance
                    .ref()
                    .child('topic_audio/$fileName');
                StorageUploadTask uploadTask =
                    storageReference.putFile(File(file.path));
                await uploadTask.onComplete;
                print('File Uploaded');
                storageReference.getDownloadURL().then((fileURL) {
                  setState(() {
                    _uploadedFileURL = fileURL;
                    _audioUrl = fileURL;
                    // set audio in database
                    topicDB.setValue(
                        widget.title, "audioURL", _uploadedFileURL);
                  });
                });
                setState(() {
                  audioLoaderFlag = false;
                });
                Toast.show("Audio Updated", context,
                    duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
              }

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomNav(startPage: 2),
                ),
              );
            },
            radius: 30,
            height: 50,
            textSize: 16,
            icon: Icon(Icons.play_arrow, color: appTheme)),
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
        (_videoUrl != "" && _betterPlayerController != null)
            ? AspectRatio(
                aspectRatio: 16 / 9,
                child: BetterPlayer(
                  controller: _betterPlayerController,
                ),
              )
            : Center(child: Text("Video could not be loaded")),
        if (_videoUrl != "" && _betterPlayerController != null)
          SizedBox(height: 5),
        if (videoLoaderFlag)
          SpinKitFadingCircle(
            color: appTheme,
            size: 50.0,
          ),
        if (videoLoaderFlag) SizedBox(height: 5),
        InkCard(
            title: _videoUrl != '' ? "Update your video" : "Upload your video",
            press: () async {
              var file = await FilePicker.getFile(type: FileType.video);
              var fileName = p.basename(file.path);
              if (fileName != '') {
                if (_videoUrl != '') {
                  String delUrl =
                      await topicDB.getValue(widget.title, 'videoURL');
                  FirebaseStorage.instance
                      .getReferenceFromUrl(delUrl)
                      .then((res) {
                    res.delete().then((res) {
                      print("Deleted!");
                    });
                  });
                }
                setState(() {
                  videoLoaderFlag = true;
                });
                StorageReference storageReference = FirebaseStorage.instance
                    .ref()
                    .child('topic_vids/$fileName');
                StorageUploadTask uploadTask =
                    storageReference.putFile(File(file.path));
                await uploadTask.onComplete;

                String fileURL = await storageReference.getDownloadURL();
                setState(() {
                  _uploadedFileURL = fileURL;
                  _videoUrl = fileURL;
                  // set video in database
                  topicDB.setValue(widget.title, "videoURL", _uploadedFileURL);
                });
                print('File Uploaded');
                setState(() {
                  videoLoaderFlag = false;
                });

                Toast.show("Video Updated", context,
                    duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
              }

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomNav(startPage: 2),
                ),
              );
            },
            radius: 30,
            height: 50,
            textSize: 16,
            icon: Icon(Icons.video_call, color: appTheme)),
        SizedBox(height: 20),
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

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:who_knows/config/constants.dart';
import 'package:who_knows/models/topicdb.dart';
import 'package:who_knows/screens/account_details.dart';
import 'package:who_knows/utils/store.dart';
import 'package:who_knows/widgets/bottom_nav.dart';
import 'package:who_knows/widgets/general/dropdown.dart';
import 'package:who_knows/widgets/general/user_info.dart';
import 'package:who_knows/widgets/login/login_button.dart';
import 'package:who_knows/widgets/user_profile/topic_details.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _topicKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  FocusNode _focusIntro = new FocusNode();
  FocusNode _focusTitle = new FocusNode();
  TopicDB topicDB = TopicDB();
  List<Map<String, dynamic>> queryDoc = [];
  String _tier = tlist[0];
  bool isActive = false;
  TopicDetails topicDetails;
  String _currentTitle = '';
  Offset position;
  Map<String, bool> topicBtnColorHandle = Map();

  @override
  void initState() {
    super.initState();
    topicDB.getAllTopicsPerUser().then((value) {
      setState(() {
        queryDoc = value;
        for (var e in queryDoc) {
          topicBtnColorHandle[e['title']] = false;
        }
      });
    });
  }

  @override
  void didUpdateWidget(UserProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    topicDB.getAllTopicsPerUser().then((value) {
      setState(() {
        queryDoc = value;
        for (var e in queryDoc) {
          topicBtnColorHandle[e['title']] = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: GestureDetector(
        onTap: () {
          if (_focusIntro.hasFocus) _focusIntro.unfocus();
        },
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UserInfo(),
                  Center(
                    child: LoginButton(
                      width: 350,
                      height: 45,
                      color: Colors.orange[800],
                      onPressed: () async {
                        await buildShowDialog(context);
                        queryDoc = await topicDB.getAllTopicsPerUser();
                        setState(() {
                          for (var e in queryDoc) {
                            topicBtnColorHandle[e['title']] = false;
                          }
                        });
                      },
                      text: "Add Skill",
                      icon: Icon(
                        Icons.arrow_right,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  if (queryDoc.length > 0)
                    Column(children: [
                      for (int i = 0; i < queryDoc.length; i += 3)
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              for (int j = i;
                                  j < i + 3 && j < queryDoc.length;
                                  j++)
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(
                                    widthFactor: 1.2,
                                    heightFactor: 1.2,
                                    child: RaisedButton.icon(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      onLongPress: () async {
                                        await buildDeleteDialog(
                                            queryDoc[j]['title'], context);
                                        List<Map<String, dynamic>> value =
                                            await topicDB.getAllTopicsPerUser();
                                        setState(() {
                                          queryDoc = value;
                                          for (var e in queryDoc) {
                                            topicBtnColorHandle[e['title']] =
                                                false;
                                          }
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BottomNav(startPage: 2),
                                            ),
                                          );
                                        });
                                      },
                                      onPressed: () {
                                        setState(() {
                                          topicBtnColorHandle.updateAll(
                                              (title, val) => val = false);
                                          topicBtnColorHandle[queryDoc[j]
                                                  ['title']] =
                                              !topicBtnColorHandle[queryDoc[j]
                                                  ['title']];
                                          _currentTitle = queryDoc[j]['title'];
                                          isActive = true;
                                          topicDetails = new TopicDetails(
                                            title: queryDoc[j]['title'],
                                            isCallActive: queryDoc[j]
                                                ['isCallActive'],
                                            isVideoActive: queryDoc[j]
                                                ['isVideoActive'],
                                            focusIntro: _focusIntro,
                                          );
                                        });
                                      },
                                      color: topicBtnColorHandle[queryDoc[j]
                                              ['title']]
                                          ? Colors.blue[100]
                                          : Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      icon: const Icon(Icons.assignment,
                                          size: 15, color: appTextColor),
                                      label: Text("${queryDoc[j]['title']}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          )),
                                      textColor: appTextColor,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ]),
                  SizedBox(height: 10),
                  isActive && topicDetails != null ? topicDetails : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              if (_focusTitle.hasFocus) _focusTitle.unfocus();
            },
            child: StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                title: Text(
                  "Add Skill",
                  style: TextStyle(
                      color: appTextColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                elevation: 0,
                content: Container(
                  height: 150.0,
                  width: 250.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Form(
                        key: _topicKey,
                        child: TextFormField(
                          controller: _titleController,
                          decoration: new InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            labelText: "Topic Title",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                          ),
                          validator: (val) {
                            if (val.length > 10) {
                              return 'Topic should have less than 10 characters';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          focusNode: _focusTitle,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FormTitle(title: "Tier"),
                          DropDown(
                            list: tlist,
                            value: _tier,
                            onChanged: (val) => setState(() {
                              if (val == 'Premium') {
                                _tier = tlist[0];
                              } else {
                                _tier = val;
                              }
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  new FlatButton(
                    child: const Text("Close", style: TextStyle(fontSize: 17)),
                    onPressed: () {
                      setState(() {
                        _titleController.text = '';
                        _tier = tlist[0];
                      });
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },
                  ),
                  new FlatButton(
                    child: const Text("Ok", style: TextStyle(fontSize: 17)),
                    onPressed: () {
                      if (_topicKey.currentState.validate()) {
                        topicDB.createTopic(_titleController.text, _tier);
                        setState(() {
                          _tier = tlist[0];
                          _titleController.text = '';
                        });
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNav(startPage: 2),
                          ),
                        );
                      }
                    },
                  ),
                ],
              );
            }),
          );
        });
  }

  Future buildDeleteDialog(String title, BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              if (_focusTitle.hasFocus) _focusTitle.unfocus();
            },
            child: StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                title: Text(
                  "Delete Skill",
                  style: TextStyle(
                      color: appTextColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                elevation: 0,
                content: Container(
                  height: 50.0,
                  width: 75.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Are you sure you want to delete this skill?"),
                    ],
                  ),
                ),
                actions: [
                  new FlatButton(
                    child: const Text("Close", style: TextStyle(fontSize: 17)),
                    onPressed: () {
                      setState(() {});
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },
                  ),
                  new FlatButton(
                    child: const Text("Yes", style: TextStyle(fontSize: 17)),
                    onPressed: () async {
                      String delAudioUrl =
                          await topicDB.getValue(title, 'audioURL');
                      FirebaseStorage.instance
                          .getReferenceFromUrl(delAudioUrl)
                          .then((res) {
                        res.delete().then((res) {
                          print("Deleted Audio!");
                        });
                      });
                      String delVideoUrl =
                          await topicDB.getValue(title, 'videoURL');
                      FirebaseStorage.instance
                          .getReferenceFromUrl(delVideoUrl)
                          .then((res) {
                        res.delete().then((res) {
                          print("Deleted Video!");
                        });
                      });
                      topicDB.deleteTopic(title);
                      setState(() {});
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },
                  ),
                ],
              );
            }),
          );
        });
  }
}

import 'package:flutter/material.dart';
import 'package:who_knows/config/constants.dart';
import 'package:who_knows/models/favoritedb.dart';
import 'package:who_knows/models/topicdb.dart';
import 'package:who_knows/models/whoknows_userdb.dart';
import 'package:who_knows/screens/pickup_layout.dart';
import 'package:who_knows/widgets/stats/stats_info.dart';
import 'package:who_knows/widgets/stats/stats_topics.dart';

class StatsProfile extends StatefulWidget {
  final String username;

  const StatsProfile({Key key, @required this.username}) : super(key: key);
  @override
  _StatsProfileState createState() => _StatsProfileState();
}

class _StatsProfileState extends State<StatsProfile> {
  FocusNode _focusIntro = new FocusNode();
  WhoKnowsUserDB whoKnowsUserDB = WhoKnowsUserDB();
  TopicDB topicDB = TopicDB();
  FavoriteDB favoriteDB = FavoriteDB();
  List<Map<String, dynamic>> queryDoc = [];
  bool isActive = false;
  bool _isFav = false;
  StatsTopics topicDetails;
  Offset position;
  Map<String, bool> topicBtnColorHandle = Map();

  @override
  void initState() {
    super.initState();
    topicDB.getAllTopicsPerUser(username: widget.username).then((value) {
      setState(() {
        queryDoc = value;
        for (var e in queryDoc) {
          topicBtnColorHandle[e['title']] = false;
        }
      });
    });
    favoriteDB.isInFavorites(widget.username).then((value) {
      if (value) _isFav = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: Colors.grey[100],
        body: GestureDetector(
          onTap: () {
            if (_focusIntro.hasFocus) _focusIntro.unfocus();
          },
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                margin: EdgeInsets.only(top: 50, left: 10, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 15),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.grey[500],
                              blurRadius: 1.0, // soften the shadow
                              spreadRadius: 0.5, //extend the shadow
                              offset: Offset(
                                2.0, // Move to right 10  horizontally
                                1.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ], shape: BoxShape.circle, color: Colors.white),
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.arrow_back,
                                  color: appTheme, size: 25)),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width - 140),
                        IconButton(
                          onPressed: () async {
                            if (!_isFav) {
                              String uidToAdd =
                                  await whoKnowsUserDB.getId(widget.username);
                              await favoriteDB.addFavorite(
                                  uidToAdd, widget.username);
                            } else {
                              String uidToAdd =
                                  await whoKnowsUserDB.getId(widget.username);
                              await favoriteDB.removeFavorite(uidToAdd);
                            }
                            setState(() {
                              _isFav = !_isFav;
                            });
                          },
                          icon: Icon(
                              _isFav ? Icons.favorite : Icons.favorite_border,
                              color: Colors.red,
                              size: 30),
                        ),
                      ],
                    ),
                    StatsInfo(
                      username: widget.username,
                    ),
                    if (queryDoc.length > 0)
                      Column(
                        children: [
                        for (int i = 0; i < queryDoc.length; i += 3)
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.center,
                            child: Row(
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
                                        onPressed: () {
                                          setState(() {
                                            topicBtnColorHandle.updateAll(
                                                (title, val) => val = false);
                                            topicBtnColorHandle[queryDoc[j]
                                                    ['title']] =
                                                !topicBtnColorHandle[queryDoc[j]
                                                    ['title']];
                                            isActive = true;
                                            topicDetails = new StatsTopics(
                                              username: widget.username,
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
                                          borderRadius:
                                              BorderRadius.circular(30),
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
                    isActive && topicDetails != null
                        ? topicDetails
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

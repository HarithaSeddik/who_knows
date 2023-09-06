import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:who_knows/config/constants.dart';
import 'package:who_knows/models/whoknows_userdb.dart';
import 'package:who_knows/utils/store.dart';
import 'package:who_knows/widgets/stats/stats_profile.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  WhoKnowsUserDB _knowsUserDB = WhoKnowsUserDB();
  List<Map<String, dynamic>> queryDoc = [];
  bool loaderFlag = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      loaderFlag = true;
    });
    _knowsUserDB.getTopUsers().then((value) {
      setState(() {
        queryDoc = value;
        loaderFlag = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            margin: EdgeInsets.only(top: 100, left: 10, right: 10),
            child: Column(
              children: [
                if (loaderFlag)
                  SpinKitFadingCircle(
                    color: appTheme,
                    size: 50.0,
                  ),
                if (loaderFlag) SizedBox(height: 5),
                if (!loaderFlag)
                  TopUsersStats(
                    title: "Top Users",
                    mapList: queryDoc,
                  ),
                SizedBox(height: 20),
                StatList(
                  title: "Hot Topics",
                  mapList: hotTopics,
                ),
                SizedBox(height: 20),
                StatList(
                  title: "WhoKnows Wanted",
                  mapList: hotTopics,
                ),
                SizedBox(height: 20),
              ],
            )),
      ),
    );
  }
}

class TopUsersStats extends StatelessWidget {
  final String title;
  final List mapList;
  const TopUsersStats({
    Key key,
    @required this.mapList,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "$title\n",
                    style: TextStyle(
                      fontSize: appAltTitleSize,
                      color: appTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.only(top: 0, bottom: 20, left: 20, right: 20),
          height: MediaQuery.of(context).size.height * 0.30,
          width: MediaQuery.of(context).size.width - 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
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
          ),
          child: ListView.builder(
            itemCount: mapList.length,
            itemBuilder: (context, position) {
              return Row(
                children: [
                  Text("${position + 1}"),
                  UserStatsInfo(
                    username: mapList[position]['username'],
                    profilePic: "${mapList[position]['profilePic']}",
                    rating: mapList[position]['rating'].toString(),
                    isOnline: mapList[position]['isOnline'] ?? false,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class StatList extends StatelessWidget {
  final String title;
  final List mapList;

  const StatList({
    Key key,
    @required this.title,
    @required this.mapList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "$title\n",
                    style: TextStyle(
                      fontSize: appAltTitleSize,
                      color: appTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.only(top: 0, bottom: 20, left: 20, right: 20),
          height: MediaQuery.of(context).size.height * 0.15,
          width: MediaQuery.of(context).size.width - 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
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
          ),
          child: ListView.builder(
            itemCount: mapList.length,
            itemBuilder: (context, position) {
              return ListTile(
                contentPadding: EdgeInsets.all(0),
                leading: null,
                dense: true,
                visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                title: Text(
                  mapList[position],
                  style: TextStyle(
                    color: appTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w100,
                    letterSpacing: 1.1,
                  ),
                ),
                trailing: null,
              );
            },
          ),
        ),
      ],
    );
  }
}

class UserStatsInfo extends StatefulWidget {
  final String profilePic;
  final String username;
  final String rating;
  final bool isOnline;

  const UserStatsInfo({
    Key key,
    @required this.profilePic,
    @required this.username,
    @required this.rating,
    this.isOnline,
  }) : super(key: key);

  @override
  _UserStatsInfoState createState() => _UserStatsInfoState();
}

class _UserStatsInfoState extends State<UserStatsInfo> {
  String id = "";
  bool locIsOnline = false;

  @override
  void initState() {
    super.initState();
    locIsOnline = widget.isOnline;
    getId();
  }

  @override
  void didUpdateWidget(Widget oldwidget) {
    super.didUpdateWidget(oldwidget);
    locIsOnline = widget.isOnline;
    getId();
  }

  void getId() async {
    WhoKnowsUserDB _knowsUserDB = WhoKnowsUserDB();
    id = await _knowsUserDB.getId(widget.username);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width - 120,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => StatsProfile(
                    username: widget.username,
                  ),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundImage: widget.profilePic == ''
                              ? AssetImage("assets/images/blank.png")
                              : NetworkImage(widget.profilePic),
                        ),
                        if (id != "")
                          StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .doc(id)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data.data() != null &&
                                  snapshot.data.data()['isOnline'] !=
                                      locIsOnline) {
                                locIsOnline = snapshot.data.data()['isOnline'];

                                return Positioned(
                                  top: 37,
                                  left: 37,
                                  child: Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                        shape: BoxShape.circle,
                                        color: locIsOnline
                                            ? Colors.green
                                            : Colors.grey),
                                  ),
                                );
                              } else {
                                return Positioned(
                                  top: 37,
                                  left: 37,
                                  child: Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                        shape: BoxShape.circle,
                                        color: locIsOnline
                                            ? Colors.green
                                            : Colors.grey),
                                  ),
                                );
                              }
                            },
                          ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "@${widget.username}",
                          style: TextStyle(
                              fontSize: 14,
                              color: appTextColor,
                              fontWeight: FontWeight.bold,
                              height: 1.3),
                        ),
                        Text("Rating: ${widget.rating}",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w600,
                                height: 1.3)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

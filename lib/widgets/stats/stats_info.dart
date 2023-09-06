import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:who_knows/config/constants.dart';
import 'package:who_knows/models/whoknows_userdb.dart';

class StatsInfo extends StatefulWidget {
  final String username;

  const StatsInfo({
    Key key,
    @required this.username,
  }) : super(key: key);

  @override
  _StatsInfoState createState() => _StatsInfoState();
}

class _StatsInfoState extends State<StatsInfo> {
  WhoKnowsUserDB userDB = WhoKnowsUserDB();
  bool isOnline = false;
  String name = '';
  String profilePic = '';
  String id = "";
  String lastSeen = "";
  DateTime showTime;

  @override
  void initState() {
    super.initState();
    userDB.getDocData(username: widget.username).then((value) {
      setState(() {
        name = value['name'] ?? '';
        isOnline = value['isOnline'] ?? false;
        profilePic = value['profilePic'] ?? '';
        lastSeen = DateTime.parse(value['lastSeen']).toLocal().toString() ?? '';
      });
    });
    getId();
  }

  void getId() async {
    id = await userDB.getId(widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Container(
        height: 150,
        width: MediaQuery.of(context).size.width - 40,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Stack(
                  children: [
                    RaisedButton(
                      shape: CircleBorder(),
                      elevation: 0,
                      color: Colors.grey[100],
                      onPressed: () async {},
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: profilePic == ''
                            ? AssetImage("assets/images/blank.png")
                            : NetworkImage(profilePic),
                      ),
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
                              snapshot.data.data()['isOnline'] != isOnline) {
                            isOnline = snapshot.data.data()['isOnline'];

                            return Positioned(
                              top: 80,
                              left: 90,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    shape: BoxShape.circle,
                                    color:
                                        isOnline ? Colors.green : Colors.grey),
                              ),
                            );
                          } else {
                            return Positioned(
                              top: 80,
                              left: 90,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    shape: BoxShape.circle,
                                    color:
                                        isOnline ? Colors.green : Colors.grey),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: new Image.asset(
                        'assets/images/icons/mgpl.png',
                        height: 20.0,
                        width: 20.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      name ?? "",
                      style: TextStyle(
                          fontSize: 18,
                          color: appTextColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "@${widget.username}",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w600),
                    ),
                    if (lastSeen != "")
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(id)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data.data() != null &&
                              DateTime.parse(snapshot.data.data()['lastSeen'])
                                      .toLocal()
                                      .toString() !=
                                  lastSeen) {
                            lastSeen = snapshot.data.data()['lastSeen'];
                            showTime = DateTime.parse(lastSeen).toLocal();
                            if (isOnline == true) {
                              return Text(
                                "Online",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.w600),
                              );
                            } else {
                              return Text(
                                "Last seen on ${showTime.day.toString().padLeft(2, '0')}/$showTime.month.toString().padLeft(2, '0')}/${showTime.year} at ${showTime.hour.toString().padLeft(2, '0')}:${showTime.minute.toString().padLeft(2, '0')}",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.w600),
                              );
                            }
                          } else {
                            showTime = DateTime.parse(lastSeen).toLocal();
                            if (isOnline == true) {
                              return Text(
                                "Online",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.w600),
                              );
                            } else {
                              return Text(
                                "Last seen on ${showTime.day.toString().padLeft(2, '0')}/${showTime.month.toString().padLeft(2, '0')}/${showTime.year} at ${showTime.hour.toString().padLeft(2, '0')}:${showTime.minute.toString().padLeft(2, '0')}",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.w600),
                              );
                            }
                          }
                        },
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

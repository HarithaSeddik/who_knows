import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:who_knows/config/constants.dart';
import 'package:who_knows/models/topicdb.dart';
import 'package:who_knows/models/whoknows_userdb.dart';
import 'package:who_knows/utils/store.dart';
import 'package:who_knows/widgets/general/dropdown.dart';
import 'package:who_knows/widgets/stats/stats_profile.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  FocusNode _focusSearch = new FocusNode();
  WhoKnowsUserDB _knowsUserDB = WhoKnowsUserDB();
  TopicDB _topicDB = TopicDB();
  List<Map<String, dynamic>> queryDoc;
  Map<String, List<Map<String, dynamic>>> queryTopics;
  bool _changeSearchBorder = false;
  bool _hideLogo = false;
  String _isSwitched = "none";
  bool _isSearchTypeSwitched = false;
  String _searchText = '';
  String _gender = glist[0];
  String _country = clist[0];
  String _tier = tierSearchList[0];
  String _callType = callList[0];
  RangeValues _currentRangeValues = const RangeValues(1, 5);

  @override
  void initState() {
    super.initState();
    _knowsUserDB.getSearchUsers().then((value) {
      setState(() {
        queryDoc = value;
      });
    });
    _topicDB.getAllTopics().then((value) {
      setState(() {
        queryTopics = value;
      });
    });
    _searchController.addListener(() => {
          setState(() {
            _searchText = _searchController.text;
          })
        });
    _focusSearch.addListener(() {
      if (_focusSearch.hasFocus) {
        setState(() {
          _changeSearchBorder = true;
        });
      } else {
        setState(() {
          _changeSearchBorder = false;
        });
      }
    });
  }

  @override
  void didUpdateWidget(SearchScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _knowsUserDB.getTopUsers().then((value) {
      setState(() {
        queryDoc = value;
      });
    });
    _topicDB.getAllTopics().then((value) {
      setState(() {
        queryTopics = value;
      });
    });
    _searchController.addListener(() => {
          setState(() {
            _searchText = _searchController.text;
          })
        });
    _focusSearch.addListener(() {
      if (_focusSearch.hasFocus) {
        setState(() {
          _changeSearchBorder = true;
        });
      } else {
        setState(() {
          _changeSearchBorder = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: GestureDetector(
        onTap: () {
          if (_focusSearch.hasFocus) {
            _focusSearch.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: EdgeInsets.only(top: 70, left: 10, right: 10),
              child: Column(children: [
                _hideLogo
                    ? Row(
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
                                  if (_focusSearch.hasFocus) {
                                    _focusSearch.unfocus();
                                  }
                                  setState(() {
                                    _isSwitched = "none";
                                    _hideLogo = false;
                                  });
                                },
                                icon: Icon(Icons.arrow_back,
                                    color: appTheme, size: 25)),
                          ),
                        ],
                      )
                    : Container(),
                _hideLogo
                    ? Container()
                    : Image.asset("assets/images/logo2.png",
                        width: MediaQuery.of(context).size.width * 0.30,
                        height: MediaQuery.of(context).size.height * 0.30),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                        color: _changeSearchBorder ? appTheme : Colors.grey,
                        width: 0.5),
                  ),
                  child: TextFormField(
                    onTap: () {
                      setState(() {
                        _hideLogo = true;
                      });
                    },
                    controller: _searchController,
                    style: TextStyle(fontSize: 13, height: 1.5),
                    decoration: InputDecoration(
                      icon: Icon(Icons.search),
                      suffixIcon: !_isSearchTypeSwitched
                          ? IconButton(
                              onPressed: () {
                                buildShowDialog(context);
                              },
                              icon: Icon(Icons.filter_list))
                          : IconButton(
                              onPressed: () {
                                buildTopicShowDialog(context);
                              },
                              icon: Icon(Icons.filter_list)),
                      labelText: "Search",
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.text,
                    autovalidate: true,
                    autocorrect: false,
                    focusNode: _focusSearch,
                  ),
                ),
                _hideLogo
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Users"),
                          Switch(
                            value: _isSearchTypeSwitched,
                            onChanged: (value) {
                              setState(() {
                                _isSearchTypeSwitched = !_isSearchTypeSwitched;
                              });
                            },
                            activeTrackColor: appTheme,
                            activeColor: Colors.white,
                          ),
                          Text("Topics"),
                        ],
                      )
                    : Container(),
                _hideLogo
                    ? Container(
                        margin:
                            EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        padding: EdgeInsets.only(
                            top: 0, bottom: 20, left: 20, right: 20),
                        height: 500,
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
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              if (!_isSearchTypeSwitched && queryDoc != null && queryTopics != null)
                                SearchUser(
                                  mapList: queryDoc.where((element) {
                                    return element['username']
                                        .toString()
                                        .toLowerCase()
                                        .contains(_searchController.text
                                            .toLowerCase());
                                  }).where((element) {
                                    if (_gender == "All")
                                      return true;
                                    else
                                      return (element['gender'] == _gender);
                                  }).where((element) {
                                    if (_country == "All")
                                      return true;
                                    else
                                      return element['country'] == _country;
                                  }).where((element) {
                                    if (_isSwitched == 'none') {
                                      return true;
                                    }
                                    return element['isOnline'] ==
                                        ((_isSwitched == 'false')
                                            ? false
                                            : true);
                                  }).toList(),
                                ),
                              if (_isSearchTypeSwitched)
                                SearchUser(
                                  mapList: queryDoc.where((element) {
                                    bool flag = false;
                                    for (var topic
                                        in queryTopics[element['username']]) {
                                      if ((topic['title']
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(_searchController
                                                      .text
                                                      .toLowerCase()) ||
                                              _searchController.text == '') &&
                                          (topic['rating'] <=
                                                  _currentRangeValues.end &&
                                              topic['rating'] >=
                                                  _currentRangeValues.start) &&
                                          (topic['gender'] == _gender ||
                                              _gender == 'All') &&
                                          (topic['country'] == _country ||
                                              _country == 'All') &&
                                          (topic['isOnline'] ==
                                              ((_isSwitched == 'true')
                                                  ? true
                                                  : false) || _isSwitched == 'none') &&
                                          ((_callType == 'Phone' &&
                                                  topic['isCallActive'] ==
                                                      true) ||
                                              (_callType == 'Video' &&
                                                  topic['isVideoActive'] ==
                                                      true) ||
                                              (_callType == 'All'))) {
                                        flag = true;
                                        break;
                                      }
                                    }

                                    return flag;
                                  }).toList(),
                                )
                            ],
                          ),
                        ),
                      )
                    : Container(),
              ]),
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
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                title: Text("Filter Search",
                    style: TextStyle(
                        color: appTextColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600)),
                elevation: 0,
                content: Container(
                  height: 250.0,
                  width: 300.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Scrollbar(
                    isAlwaysShown: true,
                    controller: _scrollController,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FormTitle(title: "Gender"),
                              DropDown(
                                list: glist,
                                value: _gender,
                                onChanged: (val) => setState(() {
                                  _gender = val;
                                }),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FormTitle(title: "Country"),
                              DropDown(
                                list: clist,
                                value: _country,
                                onChanged: (val) => setState(() {
                                  _country = val;
                                }),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FormTitle(title: "Tier"),
                              DropDown(
                                list: tierSearchList,
                                value: _tier,
                                onChanged: (val) => setState(() {
                                  _tier = val;
                                }),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FormTitle(title: "Online Status"),
                              Switch(
                                value: (_isSwitched == 'none' ||
                                        _isSwitched == 'false')
                                    ? false
                                    : true,
                                onChanged: (value) {
                                  setState(() {
                                    _isSwitched =
                                        value == false ? 'false' : 'true';
                                  });
                                },
                                activeTrackColor: appTheme,
                                activeColor: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  new FlatButton(
                    child: const Text("Close", style: TextStyle(fontSize: 17)),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },
                  ),
                  new FlatButton(
                    child: const Text("Ok", style: TextStyle(fontSize: 17)),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },
                  ),
                ],
              );
            },
          );
        });
  }

  Future buildTopicShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                title: Text("Filter Search",
                    style: TextStyle(
                        color: appTextColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600)),
                elevation: 0,
                content: Container(
                  height: 290.0,
                  width: 300.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Scrollbar(
                    isAlwaysShown: true,
                    controller: _scrollController,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FormTitle(title: "Gender"),
                              DropDown(
                                list: glist,
                                value: _gender,
                                onChanged: (val) => setState(() {
                                  _gender = val;
                                }),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FormTitle(title: "Country"),
                              DropDown(
                                list: clist,
                                value: _country,
                                onChanged: (val) => setState(() {
                                  _country = val;
                                }),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FormTitle(title: "Tier"),
                              DropDown(
                                list: tierSearchList,
                                value: _tier,
                                onChanged: (val) => setState(() {
                                  _tier = val;
                                }),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FormTitle(title: "Call Type"),
                              DropDown(
                                list: callList,
                                value: _callType,
                                onChanged: (val) => setState(() {
                                  _callType = val;
                                }),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FormTitle(title: "Online Status"),
                              Switch(
                                value: (_isSwitched == 'none' ||
                                        _isSwitched == 'false')
                                    ? false
                                    : true,
                                onChanged: (value) {
                                  setState(() {
                                    _isSwitched =
                                        value == false ? 'false' : 'true';
                                  });
                                },
                                activeTrackColor: appTheme,
                                activeColor: Colors.white,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FormTitle(title: "Rating"),
                            ],
                          ),
                          RangeSlider(
                            values: _currentRangeValues,
                            min: 1,
                            max: 5,
                            divisions: 5,
                            labels: RangeLabels(
                              _currentRangeValues.start.round().toString(),
                              _currentRangeValues.end.round().toString(),
                            ),
                            onChanged: (RangeValues values) {
                              setState(() {
                                _currentRangeValues = values;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  new FlatButton(
                    child: const Text("Close", style: TextStyle(fontSize: 17)),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },
                  ),
                  new FlatButton(
                    child: const Text("Ok", style: TextStyle(fontSize: 17)),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },
                  ),
                ],
              );
            },
          );
        });
  }
}

class FormTitle extends StatelessWidget {
  final String title;
  const FormTitle({
    Key key,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "$title",
        style: TextStyle(
          fontSize: appTitleSize,
          color: appTextColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class SearchUser extends StatelessWidget {
  final List mapList;
  const SearchUser({
    Key key,
    @required this.mapList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (var e in mapList)
          ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Container(
              height: 100,
              width: MediaQuery.of(context).size.width - 40,
              margin: EdgeInsets.only(bottom: 10, right: 10),
              padding: EdgeInsets.all(10),
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
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: UserStatsInfo(
                username: e['username'],
                profilePic: "${e['profilePic']}",
                rating: e['rating'].toString(),
                isOnline: e['isOnline'] ?? false,
              ),
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
                          )));
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

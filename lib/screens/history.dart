import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:who_knows/config/constants.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  TextEditingController _searchController = TextEditingController();
  FocusNode _focusSearch = new FocusNode();
  bool _changeSearchBorder = false;
  bool _isCall = true;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
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
          if (_focusSearch.hasFocus) _focusSearch.unfocus();
        },
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: EdgeInsets.only(top: 100, left: 10, right: 10),
              child: Column(
                children: [
                  DefaultTabController(
                    length: 2,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      height: 50,
                      decoration: BoxDecoration(
                        color: appTheme,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TabBar(
                        indicator: BubbleTabIndicator(
                          tabBarIndicatorSize: TabBarIndicatorSize.tab,
                          indicatorHeight: 40,
                          indicatorColor: Colors.white,
                        ),
                        labelStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                        labelColor: appTheme,
                        unselectedLabelColor: Colors.white,
                        tabs: <Widget>[
                          Text("Calls"),
                          Text("Messages"),
                        ],
                        onTap: (index) {
                          if (index == 0) {
                            setState(() {
                              _isCall = true;
                            });
                          } else {
                            setState(() {
                              _isCall = false;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: _changeSearchBorder ? appTheme : Colors.grey,
                          width: 0.5),
                    ),
                    child: TextFormField(
                      controller: _searchController,
                      style: TextStyle(fontSize: 13, height: 1.5),
                      decoration: InputDecoration(
                        icon: Icon(Icons.search),
                        labelText: "Search",
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.text,
                      autovalidate: true,
                      autocorrect: false,
                      focusNode: _focusSearch,
                    ),
                  ),
                  
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CallUserInfo extends StatelessWidget {
  final String profilePic;
  final String username;
  final String rating;
  final String numCalls;
  final String date;
  final String callDirection;
  final String duration;

  const CallUserInfo({
    Key key,
    @required this.profilePic,
    @required this.username,
    @required this.rating,
    @required this.numCalls,
    @required this.date,
    @required this.callDirection,
    @required this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width - 40,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(right: 10, bottom: 10),
        decoration: BoxDecoration(
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
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Stack(
                  children: [
                    CircleAvatar(
                        radius: 26, backgroundImage: AssetImage(profilePic)),
                    Positioned(
                      left: 100,
                      top: 110,
                      child: Container(
                        width: 27,
                        height: 27,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            shape: BoxShape.circle,
                            color: Colors.yellow),
                      ),
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
                      "$username",
                      style: TextStyle(
                          fontSize: 14,
                          color: appTextColor,
                          fontWeight: FontWeight.bold,
                          height: 1.3),
                    ),
                    Text("Rating: $rating",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w600,
                            height: 1.3)),
                    Text("($numCalls)",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w600,
                            height: 1.3)),
                  ],
                ),
                SizedBox(width: 100),
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "$date",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                            height: 1.3),
                      ),
                      Text("$callDirection",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w600,
                              height: 1.3)),
                      Text("$duration",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w600,
                              height: 1.3)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MsgUserInfo extends StatelessWidget {
  final String profilePic;
  final String username;
  final String rating;
  final bool highlight;

  const MsgUserInfo({
    Key key,
    @required this.profilePic,
    @required this.username,
    @required this.rating,
    this.highlight = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width - 40,
        margin: EdgeInsets.only(right: 10, bottom: 10),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              children: <Widget>[
                Stack(
                  children: [
                    CircleAvatar(
                        radius: 26, backgroundImage: AssetImage(profilePic)),
                    Positioned(
                      left: 100,
                      top: 110,
                      child: Container(
                        width: 27,
                        height: 27,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            shape: BoxShape.circle,
                            color: Colors.yellow),
                      ),
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
                      "$username",
                      style: TextStyle(
                          fontSize: 14,
                          color: appTextColor,
                          fontWeight: FontWeight.bold,
                          height: 1.3),
                    ),
                    Text("Rating: $rating",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w600,
                            height: 1.3)),
                  ],
                ),
                SizedBox(width: 130),
                Icon(highlight ? Icons.message : Icons.chat_bubble_outline,
                    color: appTheme, size: 26),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

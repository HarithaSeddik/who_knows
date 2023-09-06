import 'package:flutter/material.dart';
import 'package:who_knows/config/constants.dart';
import 'package:who_knows/models/favoritedb.dart';
import 'package:who_knows/screens/pickup_layout.dart';
import 'package:who_knows/screens/stats.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  TextEditingController _searchController = TextEditingController();
  FocusNode _focusSearch = new FocusNode();
  FavoriteDB favoriteDB = FavoriteDB();
  List<Map<String, dynamic>> queryDoc;
  bool _changeSearchBorder = false;
  String _searchText = '';
  bool loaderFlag = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      loaderFlag = true;
    });
    favoriteDB.getAllFavorites().then((value) {
      setState(() {
        queryDoc = value;
        loaderFlag = false;
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
    return GestureDetector(
      onTap: () {
        if (_focusSearch.hasFocus) _focusSearch.unfocus();
      },
      child: PickupLayout(
        scaffold: Scaffold(
          backgroundColor: Colors.grey[100],
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 70, left: 10, right: 10),
              child: Column(children: [
                Row(
                  children: [
                    SizedBox(width: 15),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
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
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back,
                              color: appTheme, size: 25)),
                    ),
                  ],
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
                if (loaderFlag)
                  SpinKitFadingCircle(
                    color: appTheme,
                    size: 50.0,
                  ),
                if (queryDoc != null)
                  FavoriteUser(
                      mapList: queryDoc
                          .where((element) => element['username']
                              .contains(_searchController.text))
                          .toList()),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class FavoriteUser extends StatelessWidget {
  final List mapList;
  const FavoriteUser({
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

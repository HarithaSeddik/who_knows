import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_star_rating/flutter_star_rating.dart';
import 'package:who_knows/config/constants.dart';
import 'package:who_knows/models/reviewdb.dart';
import 'package:who_knows/screens/pickup_layout.dart';

class ReviewScreen extends StatefulWidget {
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final TextEditingController introController = TextEditingController();

  final FocusNode focusNode = FocusNode();

  double rating = 0;
  CollectionReference callCollection;
  DocumentSnapshot data;

  @override
  void initState() {
    super.initState();
    callCollection = FirebaseFirestore.instance.collection("calls");
    callCollection.doc(FirebaseAuth.instance.currentUser.uid).get().then((value){
      setState(() {
        data = value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: GestureDetector(
        onTap: () {
          if (focusNode.hasFocus) focusNode.unfocus();
          setState(() {
            rating = 0.0;
          });
        },
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 70, left: 10, right: 10),
              child: Column(
                children: [
                  // Row(
                  //   children: [
                  //     SizedBox(width: 15),
                  //     Container(
                  //       width: 40,
                  //       height: 40,
                  //       decoration: BoxDecoration(boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.grey[500],
                  //           blurRadius: 1.0, // soften the shadow
                  //           spreadRadius: 0.5, //extend the shadow
                  //           offset: Offset(
                  //             2.0, // Move to right 10  horizontally
                  //             1.0, // Move to bottom 10 Vertically
                  //           ),
                  //         )
                  //       ], shape: BoxShape.circle, color: Colors.white),
                  //       child: IconButton(
                  //           onPressed: () async {
                  //             CollectionReference callCollection =
                  //                 FirebaseFirestore.instance
                  //                     .collection("calls");
                  //             await callCollection
                  //                 .doc(FirebaseAuth.instance.currentUser.uid)
                  //                 .delete();
                  //             Navigator.pop(context);
                  //           },
                  //           icon: Icon(Icons.arrow_back,
                  //               color: appTheme, size: 25)),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: 50),
                  Center(
                    child: Column(
                      children: [
                        Text(
                            "Rate your experience with ${data.data()['receiver_name']}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        SizedBox(height: 10),
                        CircleAvatar(
                          radius: 70,
                          backgroundImage:
                              NetworkImage(data.data()['receiver_pic']),
                        ),
                        SizedBox(height: 20),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: RichText(
                            text: TextSpan(
                              text: "Review Message\n",
                              style: TextStyle(
                                fontSize: appAltTitleSize,
                                color: appTextColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 80,
                          child: TextFormField(
                            maxLines: 5,
                            controller: introController,
                            decoration: new InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              labelText: "Review Message",
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
                            focusNode: focusNode,
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: RichText(
                            text: TextSpan(
                              text: "Review Rating\n",
                              style: TextStyle(
                                fontSize: appAltTitleSize,
                                color: appTextColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        StarRating(
                          rating: rating,
                          starConfig: StarConfig(
                            fillColor: Colors.amber,
                            strokeColor: Colors.amber,
                            strokeWidth: 1,
                            size: 40,
                          ),
                          onChangeRating: (int rating) {
                            setState(() {
                              this.rating = rating.toDouble();
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: 120,
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 3),
                            borderRadius: BorderRadius.circular(30),
                            shape: BoxShape.rectangle,
                          ),
                          child: FlatButton.icon(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            onPressed: () async {
                              ReviewDB reviewDB = ReviewDB();
                              reviewDB.createReview(
                                  data.data()['receiver_username'],
                                  introController.text,
                                  rating.round().toDouble(),
                                  data.data()['call_topic']);
                              await callCollection
                                  .doc(FirebaseAuth.instance.currentUser.uid)
                                  .delete();
                              if (Navigator.canPop(context))
                                Navigator.pop(context);
                            },
                            color: Colors.lightGreen[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            icon: const Icon(Icons.done, color: appTextColor),
                            label: Text("Submit",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                )),
                            textColor: appTextColor,
                          ),
                        ),
                      ],
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

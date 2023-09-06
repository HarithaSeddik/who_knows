import 'package:flutter/material.dart';
import 'package:who_knows/config/constants.dart';
import 'package:who_knows/screens/pickup_layout.dart';

class Help extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Container(
          margin: EdgeInsets.only(top: 70, left: 10, right: 10),
          child: Column(
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
                        icon:
                            Icon(Icons.arrow_back, color: appTheme, size: 25)),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Center(
                child: Column(
                  children: [
                    Text("Live Support",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(height: 10),
                    Text("Live support from customer service"),
                    SizedBox(height: 10),
                    Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 3),
                        borderRadius: BorderRadius.circular(30),
                        shape: BoxShape.rectangle,
                      ),
                      child: FlatButton.icon(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        onPressed: () {},
                        color: Colors.red[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        icon: const Icon(Icons.live_help, color: appTextColor),
                        label: Text("Add",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            )),
                        textColor: appTextColor,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text("Email",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(height: 10),
                    Text("Send email for feedback or support"),
                    SizedBox(height: 10),
                    Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 3),
                        borderRadius: BorderRadius.circular(30),
                        shape: BoxShape.rectangle,
                      ),
                      child: FlatButton.icon(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        onPressed: () {},
                        color: Colors.lightBlue[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        icon: const Icon(Icons.email, color: appTextColor),
                        label: Text("Send",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            )),
                        textColor: appTextColor,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text("Frequently Asked",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(height: 10),
                    Text("Check the answer to your question"),
                    SizedBox(height: 10),
                    Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 3),
                        borderRadius: BorderRadius.circular(30),
                        shape: BoxShape.rectangle,
                      ),
                      child: FlatButton.icon(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        onPressed: () {},
                        color: Colors.yellow[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        icon: const Icon(Icons.question_answer,
                            color: appTextColor),
                        label: Text("More",
                            style: TextStyle(
                              fontSize: 10,
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
    );
  }
}

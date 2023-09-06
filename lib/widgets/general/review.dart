import 'package:flutter/material.dart';
import 'package:flutter_star_rating/flutter_star_rating.dart';
import 'package:who_knows/config/constants.dart';

class Review extends StatelessWidget {
  final String byUsername;
  final double rating;
  final String content;

  const Review({
    Key key,
    @required this.byUsername,
    @required this.rating,
    @required this.content
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: ClipRRect(
        child: Container(
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
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "@$byUsername",
                    style: TextStyle(
                        fontSize: 15,
                        color: appTextColor,
                        fontWeight: FontWeight.bold,
                        height: 1.3),
                  ),
                  StarRating(
                    rating: rating,
                    starConfig: StarConfig(
                      fillColor: Colors.amber,
                      strokeColor: Colors.amber,
                      strokeWidth: 1,
                      size: 20,
                    ),
                  ),
                ],
              ),
              SizedBox(height:10),
              RichText(
                softWrap: true,
                text: TextSpan(
                  text: content,
                  style: DefaultTextStyle.of(context).style,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

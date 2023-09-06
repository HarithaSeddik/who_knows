import 'package:flutter/material.dart';
import 'package:who_knows/config/constants.dart';

class InkCard extends StatelessWidget {
  final String title;
  final Function press;
  final double radius;
  final double height;
  final double textSize;
  final Icon icon;

  const InkCard({
    Key key,
    @required this.title,
    @required this.press,
    @required this.radius,
    @required this.height,
    @required this.textSize,
    @required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Container(
        height: this.height,
        width: MediaQuery.of(context).size.width - 40,
        margin: EdgeInsets.only(bottom: 10, right:10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(this.radius),
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
        child: Material(
          color: Colors.transparent,
          child: InkWell(
              onTap: press,
              child: Center(
                child: ListTile(
                  leading: icon,
                  title: Text(
                    title,
                    style: TextStyle(
                      color: appTextColor,
                      fontSize: textSize,
                      fontWeight: FontWeight.w100,
                      letterSpacing: 1.1,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: appTextColor,
                  ),
                ),
              )),
        ),
      ),
    );
  }
}

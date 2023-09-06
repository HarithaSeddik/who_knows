import 'package:flutter/material.dart';
import 'package:who_knows/config/constants.dart';

class LoginButton extends StatelessWidget {
  final double width;
  final double height;
  final Function onPressed;
  final String text;
  final Icon icon;
  final Color color;

  const LoginButton({
    Key key, this.width, this.height, this.onPressed, this.text, this.icon, this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: this.color==null ? appTheme : color,
      ),
      child: MaterialButton(
        onPressed: this.onPressed,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: StadiumBorder(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(this.text,style: TextStyle(color:Colors.white, fontSize: 18),),
          ],
        ),
      ),
    );
  }
} 
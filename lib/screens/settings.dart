import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:who_knows/blocs/auth_bloc/auth_bloc.dart';
import 'package:who_knows/blocs/auth_bloc/auth_events.dart';
import 'package:who_knows/config/constants.dart';
import 'package:who_knows/main.dart';
import 'package:who_knows/repos/user_repo.dart';
import 'package:who_knows/screens/account_details.dart';
import 'package:who_knows/screens/favorites.dart';
import 'package:who_knows/screens/help.dart';
import 'package:who_knows/screens/transaction_history.dart';
import 'package:who_knows/widgets/general/ink_card.dart';
import 'package:who_knows/widgets/general/user_info.dart';
import 'package:who_knows/widgets/login/login_button.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Column(
              children: [
                UserInfo(),
                SizedBox(height: 10),
                InkCard(
                    title: "Favorites",
                    press: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Favorites()));
                    },
                    radius: 30,
                    height: 50,
                    textSize: 15,
                    icon: Icon(Icons.favorite, color: appTheme)),
                SizedBox(height: 10),
                InkCard(
                    title: "WhoKnows Account",
                    press: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  TransactionHistory()));
                    },
                    radius: 30,
                    height: 50,
                    textSize: 15,
                    icon: Icon(Icons.account_circle, color: appTheme)),
                SizedBox(height: 10),
                InkCard(
                    title: "Change Details",
                    press: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AccountDetails()));
                    },
                    radius: 30,
                    height: 50,
                    textSize: 15,
                    icon: Icon(Icons.description, color: appTheme)),
                SizedBox(height: 10),
                InkCard(
                    title: "Bank Account",
                    press: () {},
                    radius: 30,
                    height: 50,
                    textSize: 15,
                    icon: Icon(Icons.account_balance, color: appTheme)),
                SizedBox(height: 10),
                InkCard(
                    title: "Help",
                    press: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Help()));
                    },
                    radius: 30,
                    height: 50,
                    textSize: 15,
                    icon: Icon(Icons.help, color: appTheme)),
                SizedBox(height: 10),
                InkCard(
                    title: "About",
                    press: () {},
                    radius: 30,
                    height: 50,
                    textSize: 15,
                    icon: Icon(Icons.info, color: appTheme)),
                SizedBox(height: 20),
                LoginButton(
                  width: 350,
                  height: 45,
                  onPressed: () {
                    BlocProvider.of<AuthenticationBloc>(context).add(
                      AuthenticationLoggedOut(),
                    );
                    UserRepository urepo = UserRepository();
                    urepo.signOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => WhoKnows()));
                  },
                  text: "Sign Out",
                  icon: Icon(
                    Icons.arrow_right,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

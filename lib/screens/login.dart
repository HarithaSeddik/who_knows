import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:who_knows/blocs/login_bloc/login_bloc.dart';
import 'package:who_knows/config/constants.dart';
import 'package:who_knows/repos/user_repo.dart';
import 'package:who_knows/widgets/login/login_form.dart';
import 'package:who_knows/widgets/login/pattern.dart';

class LoginScreen extends StatelessWidget {
  final FocusNode _focusEmail = new FocusNode();
  final FocusNode _focusPassword = new FocusNode();
  final UserRepository _userRepository;

  LoginScreen({Key key, UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(_userRepository),
              child: GestureDetector(
          onTap: () {
            if (_focusEmail.hasFocus) _focusEmail.unfocus();
            if (_focusPassword.hasFocus) _focusPassword.unfocus();
          },
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.grey[200]]),
            ),
            child: Stack(
              children: <Widget>[
                PatternWidget(
                  child: Container(
                    padding: const EdgeInsets.only(top: 100, left: 50),
                    width: double.infinity,
                    height: 500,
                    color: appTheme,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: (MediaQuery.of(context).size.height - 400) / 2,
                      left: (MediaQuery.of(context).size.width - 350) / 2),
                  child: LoginForm(
                      focusEmail: _focusEmail, focusPassword: _focusPassword, userRepository: _userRepository,),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

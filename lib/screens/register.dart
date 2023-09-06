import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:who_knows/blocs/register_bloc/register_bloc.dart';
import 'package:who_knows/config/constants.dart';
import 'package:who_knows/repos/user_repo.dart';
import 'package:who_knows/widgets/login/pattern.dart';
import 'package:who_knows/widgets/login/register_form.dart';

class Register extends StatelessWidget {
  final UserRepository userRepository;
  final FocusNode _focusName = new FocusNode();
  final FocusNode _focusUsername = new FocusNode();
  final FocusNode _focusEmail = new FocusNode();
  final FocusNode _focusPassword = new FocusNode();

  Register({Key key, this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          icon: Icon(Icons.arrow_left),
        ),
      ),
      body: Builder(builder: (BuildContext context) {
        return BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(userRepository),
          child: GestureDetector(
            onTap: () {
              if (_focusName.hasFocus) _focusName.unfocus();
              if (_focusUsername.hasFocus) _focusUsername.unfocus();
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
                    child: RegisterForm(
                        focusName: _focusName,
                        focusUsername: _focusUsername,
                        focusEmail: _focusEmail,
                        focusPassword: _focusPassword),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

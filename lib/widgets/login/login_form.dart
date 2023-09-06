import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:who_knows/blocs/auth_bloc/auth_bloc.dart';
import 'package:who_knows/blocs/auth_bloc/auth_events.dart';
import 'package:who_knows/blocs/login_bloc/login_bloc.dart';
import 'package:who_knows/blocs/login_bloc/login_event.dart';
import 'package:who_knows/blocs/login_bloc/login_state.dart';
import 'package:who_knows/config/constants.dart';
import 'package:who_knows/repos/user_repo.dart';
import 'package:who_knows/screens/register.dart';
import 'package:who_knows/widgets/login/form_text_field.dart';
import 'package:who_knows/widgets/login/login_button.dart';

class LoginForm extends StatefulWidget {
  final FocusNode focusEmail;
  final FocusNode focusPassword;
  final UserRepository userRepository;

  const LoginForm(
      {Key key,
      @required this.focusEmail,
      @required this.focusPassword,
      @required this.userRepository})
      : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = true;
  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
  bool isButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    getCheckedValue().then((value) {
      setState(() {
        checkedValue = value;
      });
    });
    if (checkedValue) {
      getEmail().then((value) {
        setState(() {
          _emailController.text = value;
        });
      });
      getPassword().then((value) {
        _passwordController.text = value;
      });
    }
    _emailController.addListener(_onEmailChange);
    _passwordController.addListener(_onPasswordChange);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isFailure) {
          if (state.isVerified == false) {
            Scaffold.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Email not verified"),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: appTheme,
              ));
          } else {
            Scaffold.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Login Failed"),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: appTheme,
              ));
          }
        } else if (state.isSubmitting) {
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Logging In..."),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ],
              ),
              backgroundColor: appTheme,
            ));
        } else if (state.isSuccess) {
          print("Success");
          BlocProvider.of<AuthenticationBloc>(context).add(
            AuthenticationLoggedIn(),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: Container(
            height: 500,
            width: 350,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 17),
                    blurRadius: 17,
                    spreadRadius: -23,
                    color: Color(0xFFE6E6E6))
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 90,
                        width: 150,
                        child: Image.asset("assets/images/logo.png"),
                      ),
                      FormTextField(
                        controller: _emailController,
                        focusNode: widget.focusEmail,
                        labelText: "Email",
                        inputType: TextInputType.emailAddress,
                        validator: (_) {
                          return !state.isEmailValid ? 'Invalid Email' : null;
                        },
                      ),
                      FormTextField(
                        controller: _passwordController,
                        focusNode: widget.focusPassword,
                        labelText: "Password",
                        inputType: TextInputType.visiblePassword,
                        validator: (_) {
                          return !state.isPasswordValid
                              ? '8-digit Password must include at least one \nuppercase, one lowercase, one numeric, \none and special character from \n( ! @ # \$ & * ~ )'
                              : null;
                        },
                      ),
                      CheckboxListTile(
                        title: Text("Remember me"),
                        value: checkedValue ?? false,
                        activeColor: appTheme,
                        onChanged: (newValue) {
                          setState(() {
                            checkedValue = newValue;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      LoginButton(
                        width: 350,
                        height: 45,
                        onPressed: () {
                          if (_formKey.currentState.validate() &&
                              isButtonEnabled(state)) {
                            _onFormSubmitted();
                          }
                        },
                        text: "Sign In",
                        icon: Icon(
                          Icons.arrow_right,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      LoginButton(
                        width: 350,
                        height: 45,
                        onPressed: () {
                          onRegisterClicked();
                        },
                        text: "Register",
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
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    widget.focusEmail.dispose();
    widget.focusPassword.dispose();
    super.dispose();
  }

  void _onEmailChange() {
    _loginBloc.add(LoginEmailChange(email: _emailController.text));
  }

  void _onPasswordChange() {
    _loginBloc.add(LoginPasswordChange(password: _passwordController.text));
  }

  void onRegisterClicked() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => Register(
                  userRepository: widget.userRepository,
                )));
  }

  Future<void> _onFormSubmitted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storage = new FlutterSecureStorage();

    if (checkedValue) {
      await prefs.setBool("checked", true);
      await prefs.setString("email", _emailController.text);
      await storage.write(key: "password", value: _passwordController.text);
    } else {
      await prefs.setBool("checked", false);
      prefs.remove("email");
      await storage.delete(key: "password");
    }

    _loginBloc.add(LoginWithCredentialsPressed(
        email: _emailController.text, password: _passwordController.text));
  }

  Future<bool> getCheckedValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("checked");
  }

  Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("email");
  }

  Future<String> getPassword() async {
    final storage = new FlutterSecureStorage();
    return await storage.read(key: "password");
  }
}

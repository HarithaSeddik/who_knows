import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:who_knows/blocs/register_bloc/register_bloc.dart';
import 'package:who_knows/blocs/register_bloc/register_event.dart';
import 'package:who_knows/blocs/register_bloc/register_state.dart';
import 'package:who_knows/config/constants.dart';
import 'package:who_knows/widgets/login/form_text_field.dart';
import 'package:who_knows/widgets/login/login_button.dart';
import 'package:who_knows/models/whoknows_userdb.dart';

class RegisterForm extends StatefulWidget {
  final FocusNode focusName;
  final FocusNode focusUsername;
  final FocusNode focusEmail;
  final FocusNode focusPassword;

  const RegisterForm(
      {Key key,
      @required this.focusName,
      @required this.focusUsername,
      @required this.focusEmail,
      @required this.focusPassword})
      : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  WhoKnowsUserDB userDB = WhoKnowsUserDB();
  final _formKey = GlobalKey<FormState>();
  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
  bool isButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  RegisterBloc _registerBloc;

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChange);
    _passwordController.addListener(_onPasswordChange);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Register Failed"),
                  Icon(Icons.error),
                ],
              ),
              backgroundColor: appTheme,
            ));
        } else if (state.isSubmitting) {
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Registering..."),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ],
              ),
              backgroundColor: appTheme,
            ));
        } else if (state.isSuccess) {
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Email verification sent"),
                  Icon(Icons.error),
                ],
              ),
              backgroundColor: appTheme,
            ));
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (BuildContext context, RegisterState state) {
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
                reverse: true,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
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
                          controller: _nameController,
                          focusNode: widget.focusName,
                          labelText: "Name",
                          inputType: TextInputType.text,
                          validator: null,
                        ),
                        FormTextField(
                          controller: _usernameController,
                          focusNode: widget.focusUsername,
                          labelText: "Username",
                          inputType: TextInputType.text,
                          validator: null,
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
                        SizedBox(height: 10),
                        LoginButton(
                          width: 350,
                          height: 45,
                          onPressed: () {
                            if (_formKey.currentState.validate() &&
                                isButtonEnabled(state)) {
                              _onFormSubmitted();
                            }
                          },
                          text: "Submit",
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
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    widget.focusName.dispose();
    widget.focusUsername.dispose();
    widget.focusEmail.dispose();
    widget.focusPassword.dispose();
    super.dispose();
  }

  void _onEmailChange() {
    _registerBloc.add(RegisterEmailChange(email: _emailController.text));
  }

  void _onPasswordChange() {
    _registerBloc
        .add(RegisterPasswordChange(password: _passwordController.text));
  }

  Future<void> _onFormSubmitted() async {
    if (await userDB.usernameCheck(_usernameController.text)) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("name", _nameController.text);
      await prefs.setString("username", _usernameController.text);
      _registerBloc.add(RegisterSubmitted(
          email: _emailController.text, password: _passwordController.text));
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Username is not unique!"),
            Icon(Icons.error),
          ],
        ),
        backgroundColor: appTheme,
      ));
    }
  }
}

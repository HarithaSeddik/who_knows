import 'package:flutter/material.dart';
import 'package:who_knows/config/constants.dart';
import 'package:who_knows/models/whoknows_userdb.dart';
import 'package:who_knows/screens/pickup_layout.dart';
import 'package:who_knows/utils/store.dart';
import 'package:who_knows/widgets/general/dropdown.dart';
import 'package:who_knows/widgets/login/login_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:who_knows/utils/validator.dart';

class AccountDetails extends StatefulWidget {
  @override
  _AccountDetailsState createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  FocusNode _focusUsername = new FocusNode();
  FocusNode _focusName = new FocusNode();
  FocusNode _focusEmail = new FocusNode();
  FocusNode _focusPassword = new FocusNode();
  FocusNode _focusPhone = new FocusNode();
  WhoKnowsUserDB userDB = WhoKnowsUserDB();
  FlutterSecureStorage storage = new FlutterSecureStorage();
  bool _obscureText = true;
  bool _isSwitched = false;
  String _gender = glist[0];
  String _country = clist[0];

  @override
  void initState() {
    super.initState();
    userDB.getDocData().then((map) {
      _usernameController.text = map["username"] ?? '';
      _nameController.text = map["name"] ?? '';
      _emailController.text = map["email"] ?? '';
      _phoneController.text = map["phone"] ?? '';
      storage.read(key: "password").then((value) {
        _passwordController.text = value ?? '';
      });
      setState(() {
        _isSwitched = map['wantNotifications'] ?? false;
        _gender = map['gender'] ?? glist[0];
        _country = map['country'] ?? clist[0];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_focusUsername.hasFocus) _focusUsername.unfocus();
        if (_focusName.hasFocus) _focusName.unfocus();
        if (_focusEmail.hasFocus) _focusEmail.unfocus();
        if (_focusPassword.hasFocus) _focusPassword.unfocus();
        if (_focusPhone.hasFocus) _focusPhone.unfocus();
      },
      child: PickupLayout(
        scaffold: Scaffold(
          backgroundColor: Colors.grey[100],
          body: Builder(
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: 70, left: 10, right: 10),
                  child: Column(children: [
                    Row(
                      children: [
                        SizedBox(width: 15),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
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
                          ),
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.arrow_back,
                                  color: appTheme, size: 25)),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 1),
                      child: new Center(
                        child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                readOnly: true,
                                controller: _usernameController,
                                decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 20),
                                  labelText: "Username",
                                  fillColor: Colors.white,
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                    borderSide: new BorderSide(),
                                  ),
                                ),
                                validator: (val) {
                                  return null;
                                },
                                keyboardType: TextInputType.text,
                                focusNode: _focusUsername,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: _nameController,
                                decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 20),
                                  labelText: "Name/Surname",
                                  fillColor: Colors.white,
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                    borderSide: new BorderSide(),
                                  ),
                                ),
                                validator: (val) {
                                  return null;
                                },
                                keyboardType: TextInputType.text,
                                focusNode: _focusName,
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FormTitle(title: "Gender"),
                                  DropDown(
                                      list: glist,
                                      value: _gender,
                                      onChanged: (val) => setState(() {
                                            _gender = val;
                                          })),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: _emailController,
                                decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 20),
                                  labelText: "Email",
                                  fillColor: Colors.white,
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                    borderSide: new BorderSide(),
                                  ),
                                ),
                                validator: (val) {
                                  return null;
                                },
                                keyboardType: TextInputType.emailAddress,
                                focusNode: _focusEmail,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscureText,
                                decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 20),
                                  labelText: "Password",
                                  fillColor: Colors.white,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                      _obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey[500],
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                  ),
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                    borderSide: new BorderSide(),
                                  ),
                                ),
                                validator: (val) {
                                  return null;
                                },
                                keyboardType: TextInputType.visiblePassword,
                                focusNode: _focusPassword,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: _phoneController,
                                decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 20),
                                  labelText: "Phone no.",
                                  fillColor: Colors.white,
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                    borderSide: new BorderSide(),
                                  ),
                                ),
                                validator: (val) {
                                  return null;
                                },
                                keyboardType: TextInputType.phone,
                                focusNode: _focusPhone,
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FormTitle(title: "Country"),
                                  DropDown(
                                    list: clist,
                                    value: _country,
                                    onChanged: (val) => setState(() {
                                      _country = val;
                                    }),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FormTitle(title: "Enable Notifications"),
                                  Switch(
                                    value: _isSwitched,
                                    onChanged: (value) {
                                      setState(() {
                                        _isSwitched = value;
                                      });
                                    },
                                    activeTrackColor: appTheme,
                                    activeColor: Colors.white,
                                  ),
                                ],
                              ),
                            ]),
                      ),
                    ),
                    SizedBox(height: 20),
                    LoginButton(
                      width: 350,
                      height: 45,
                      onPressed: () async {
                        int i = await _onFormSubmitted();
                        if (i == 0) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Submitted"),
                                Icon(Icons.check),
                              ],
                            ),
                            backgroundColor: appTheme,
                          ));
                        } else if (i == -1) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Password format not correct!"),
                                Icon(Icons.error),
                              ],
                            ),
                            backgroundColor: appTheme,
                          ));
                        } else if (i == -2) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Email format not correct!"),
                                Icon(Icons.error),
                              ],
                            ),
                            backgroundColor: appTheme,
                          ));
                        }
                      },
                      text: "Submit",
                      icon: Icon(
                        Icons.arrow_right,
                        color: Colors.white,
                      ),
                    ),
                  ]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<int> _onFormSubmitted() async {
    int status = 0;
    dynamic map = await userDB.getDocData();
    if (map['wantNotifications'] == null ||
        map['wantNotifications'] != _isSwitched) {
      userDB.setValue("wantNotifications", _isSwitched);
    }
    if (map['gender'] == null || map['gender'] != _gender) {
      userDB.setValue("gender", _gender);
    }
    if (map['country'] == null || map['country'] != _country) {
      userDB.setValue("country", _country);
    }
    if (map['phone'] == null || map['phone'] != _phoneController.text) {
      userDB.setValue("phone", _phoneController.text);
    }
    if (map['name'] == null || map['name'] != _nameController.text) {
      userDB.setValue("name", _nameController.text);
    }
    if (Validators.isValidEmail(_emailController.text) &&
        (map['email'] == null || map['email'] != _emailController.text)) {
      FirebaseAuth.instance.currentUser.reload();
      FirebaseAuth.instance.currentUser
          .verifyBeforeUpdateEmail(_emailController.text);
      userDB.setValue("email", _emailController.text);
    }
    if (!Validators.isValidEmail(_emailController.text)) {
      status = -2;
    }
    String val = await storage.read(key: "password");
    if (Validators.isValidPassword(_passwordController.text) &&
        val != _passwordController.text) {
      FirebaseAuth.instance.currentUser.reload();
      FirebaseAuth.instance.currentUser
          .updatePassword(_passwordController.text);
    }
    if (!Validators.isValidPassword(_passwordController.text)) {
      status = -1;
    }
    return status;
  }
}

class FormTitle extends StatelessWidget {
  final String title;
  const FormTitle({
    Key key,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "$title",
        style: TextStyle(
          fontSize: appTitleSize,
          color: appTextColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class FormTextField extends StatefulWidget {
  const FormTextField({
    Key key,
    @required this.focusNode,
    @required this.labelText,
    @required this.inputType,
    @required this.validator,
    @required this.controller,
  }) : super(key: key);

  final FocusNode focusNode;
  final TextEditingController controller;
  final String labelText;
  final TextInputType inputType;
  final Function(String) validator;

  @override
  _FormTextFieldState createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
      child: TextFormField(
        obscureText: this.widget.labelText == "Password" ? _obscureText : false,
        controller: this.widget.controller,
        decoration: new InputDecoration(
          suffixIcon: this.widget.labelText == "Password"
              ? IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey[500],
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
          contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          labelText: "${widget.labelText}",
          fillColor: Colors.white,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(25.0),
            borderSide: new BorderSide(),
          ),
        ),
        validator: this.widget.validator,
        keyboardType: widget.inputType,
        autocorrect: false,
        focusNode: widget.focusNode,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class DropDown extends StatelessWidget {
  final List<String> list;
  final String value;
  final Function(String) onChanged;

  const DropDown({
    @required this.list,
    @required this.value,
    @required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 3),
        borderRadius: BorderRadius.circular(30),
        shape: BoxShape.rectangle,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(30),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            value: value,
            items: list
                .map(
                  (e) => DropdownMenuItem(
                    child: Row(
                      children: <Widget>[
                        Text(e,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    value: e,
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}

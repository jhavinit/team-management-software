import 'package:flutter/material.dart';
class DropDownDemo extends StatefulWidget {

  final Function(String)? onChangedRole;
    DropDownDemo({required this.onChangedRole});
  @override
  _DropDownDemoState createState() => _DropDownDemoState();
}

class _DropDownDemoState extends State<DropDownDemo> {
  String? _chosenValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: DropdownButton<String>(
        value: _chosenValue,
        //elevation: 5,
        style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Montserrat'),

        items: <String>['ADMIN', 'USER']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        hint: const Text(
          "ROLE",
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Montserrat',
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
        onChanged: (String? value) {
          widget.onChangedRole!(value!);

          setState(() {
            _chosenValue = value;
          });
        },
      ),
    );
  }
}

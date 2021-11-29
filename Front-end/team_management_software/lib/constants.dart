import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Constants {

  static Color buttonColor = const Color(0xFFeccf1d);
  static String username = "";
  static String email = "";
  static String userDetails="";
  static String role="user";

  static kTextFormFieldDecoration(String labelText) {
    return InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.grey),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow[800]!)));
  }

  static kTextFormFieldDecorationForFProject(String labelText) {
    return InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
            color: Colors.grey),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow[800]!)));
  }

  static kTextFormFieldDecorationForTask(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(
        fontSize: 20,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w300,
        color: Colors.grey,
      ),
      enabledBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
    );
  }

  static kWidgetForStatusAndPriority(text, color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Text(text)),
      ],
    );
  }

}

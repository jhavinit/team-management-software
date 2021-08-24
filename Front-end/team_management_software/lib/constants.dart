import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Constants{
  static  kTextFormFieldDecoration(String labelText){
    return InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.grey),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.green)));
  }
  static Color buttonColor=   const Color(0xFFeccf1d);
}
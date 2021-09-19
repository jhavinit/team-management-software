import 'package:flutter/material.dart';
class MessageTile extends StatelessWidget {
  final String? text,side;

  const MessageTile({this.text, this.side});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: side == "left" ? Colors.grey : Colors.blueGrey,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: side != "left" ? Radius.circular(0) : Radius.circular(16),
            bottomRight:
            side == "left" ? Radius.circular(0) : Radius.circular(16)),
      ),
      //width: 20,
      child: Text(
        text!,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
    );
  }
}


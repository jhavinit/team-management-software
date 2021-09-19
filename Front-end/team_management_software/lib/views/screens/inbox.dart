import 'package:flutter/material.dart';

class Inbox extends StatefulWidget {
  const Inbox({Key? key}) : super(key: key);

  @override
  _InboxState createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30,
        automaticallyImplyLeading: false,


        title: Text("Search",style: TextStyle(color: Colors.yellow[800],fontWeight: FontWeight.w300,fontSize: 25),),
        backgroundColor: Colors.black
        ,

      ),
    );
  }
}

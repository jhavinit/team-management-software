import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController? controller;
  bool fabIsVisible = true;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    controller!.addListener(() {
      setState(() {
        fabIsVisible =
            controller!.position.userScrollDirection == ScrollDirection.forward;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        controller: controller,
        children: List.generate(
            100,
                (index) => ListTile(
              title: Text("Text $index"),
            )),
      ),
      floatingActionButton: Visibility(
        child: FloatingActionButton(
          child: Icon(Icons.add),
          tooltip: "Increment",
          onPressed: () {
            print("Pressed");
          },
        ),
        visible: fabIsVisible ? true : false,
      ),
    );
  }
}
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:team_management_software/views/components/loading_indicator.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  RefreshController _refreshController =
  RefreshController(initialRefresh: true);


   refreshFunction()async{
     print("refreshing");

   await  Future.delayed(Duration(seconds: 5));
    _refreshController.refreshCompleted();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: Colors.red,
        appBar: AppBar(toolbarHeight: 80,
          title: Text("Refresh"),
        actions: [
          IconButton(onPressed: (){
         _refreshController.requestRefresh();
          }, icon: Icon(Icons.add))

        ],),
        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: refreshFunction,
          onLoading:refreshFunction,
          header: CustomHeader(
            refreshStyle: RefreshStyle.UnFollow,
            height: 20,
            builder: (context,mode){
             return Container(
                  height: 20,
                  child:
                  Column(
                    children: [
                      LinearProgressIndicator(
                        color: Colors.yellow[800],
                        backgroundColor: Colors.black,
                        minHeight: 5,
                      ),
                     // Expanded(child: Container())
                    ],
                  ),
              );
            },
          ),
          child: ListView.builder(
            itemCount: 100,
              itemBuilder: (context,index){

            return Container(
             // padding: EdgeInsets.only(top: 20),
              child: Text("$index is the index"),
            );
          }),
        ),

    );
  }
}

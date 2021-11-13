import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../change_notifier.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final RefreshController _refreshController =
  RefreshController(initialRefresh: true);
  updatingTheList() async {
    await context.read<Data>().updateProjectListFromServer();
    await context.read<Data>().getTokensDataFromHttp();
  }


   refreshFunction()async{
     print("refreshing");

   await  updatingTheList();
   // Future.delayed(Duration(seconds: 5));
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
              if(mode==RefreshStatus.refreshing) {
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
              }else if(mode==RefreshStatus.canRefresh){
                return Center(child: Text("Leave to refresh"),);
              }
              else if(mode==RefreshStatus.idle){
                return Center(child: Text("Pull to refresh"));
              }

              return Container();
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

// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../../change_notifier.dart';

class SearchList extends StatefulWidget {
  SearchList({Key? key}) : super(key: key);
  @override
  _SearchListState createState() =>  _SearchListState();
}

class _SearchListState extends State<SearchList> {
  Widget appBarTitle =  Text(
    "Tap to Search..",
    style: new TextStyle(color: Colors.white),
  );
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  final key =  GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery =  TextEditingController();
 var _list=[];
   bool _IsSearching=false;
  String _searchText = "";

  _SearchListState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _IsSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }
  getConversationList() async {
    _list = context.watch<Data>().listOfTokensNotifier;
  }

  @override
  void initState() {
    super.initState();
    _IsSearching = false;

    init();
  }
@override
  void didChangeDependencies() {
    //getConversationList();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  void init() {
  // _list = List();
    _list = [];
    _list.add("Rohit");
    _list.add("Vikash");
    _list.add("Kuhu");
    _list.add("Sukhvir");
    // _list.add("Flutter");
    // _list.add("Python");
    // _list.add("React");
    // _list.add("Xamarin");
    // _list.add("Kotlin");
    // _list.add("Java");
    // _list.add("RxAndroid");
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      key: key,
      appBar:
          PreferredSize(
            preferredSize: Size.fromHeight(50),
            child:   buildBar(context),
          ),

      body:  ListView(
        padding:  EdgeInsets.symmetric(vertical: 8.0),
        children: _IsSearching ? _buildSearchList() : _buildList(),
      ),
    );
  }

  List<ChildItem> _buildList() {
    return _list.map((contact) =>  ChildItem(contact)).toList();
  }

  List<ChildItem> _buildSearchList() {
    if (_searchText.isEmpty) {
      return _list.map((contact) =>  ChildItem(contact)).toList();
    } else {
      List<String> _searchList = [];
      for (int i = 0; i < _list.length; i++) {
        String name = _list.elementAt(i);
        if (name.toLowerCase().contains(_searchText.toLowerCase())) {
          _searchList.add(name);
        }
      }
      return _searchList.map((contact) =>  ChildItem(contact)).toList();
    }
  }

  Widget buildBar(BuildContext context) {
    return  AppBar(
      automaticallyImplyLeading: false,
        centerTitle: true, title: appBarTitle, actions: <Widget>[
       IconButton(
        icon: actionIcon,
        onPressed: () {
          setState(() {

            if (this.actionIcon.icon == Icons.search) {
              this.actionIcon =  const Icon(
                Icons.close,
                color: Colors.white,
              );
              this.appBarTitle =  TextField(
                controller: _searchQuery,
                style:  TextStyle(
                  color: Colors.white,
                ),
                decoration:  const InputDecoration(
                    prefixIcon:  Icon(Icons.search, color: Colors.white),
                    hintText: "Search...",
                    hintStyle:  TextStyle(color: Colors.white)),
              );
              _handleSearchStart();
            } else {
              _handleSearchEnd();
            }
          });
        },
      ),
    ]);
  }

  void _handleSearchStart() {
    setState(() {
      _IsSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon =  Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle =  Text(
        "Search..",
        style: new TextStyle(color: Colors.white),
      );
      _IsSearching = false;
      _searchQuery.clear();
    });
  }
}

class ChildItem extends StatelessWidget {
  final String name;
  const ChildItem(this.name);
  @override
  Widget build(BuildContext context) {
    return  ListTile(title:  Text(this.name));
  }
}


// ignore_for_file: unnecessary_this
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
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
    style:  TextStyle(color: Colors.yellow[800]),
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
    _list.add("Vikash");
    _list.add("Kuhu");
    _list.add("Sukhvir");
    _list.add("Rohit");
    _list.add("Flutter");
    _list.add("Python");
    _list.add("React");
    _list.add("Xamarin");
    _list.add("Kotlin");
    _list.add("Java");
    _list.add("RxAndroid");
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
      backgroundColor: Colors.black,
      automaticallyImplyLeading: false,
        centerTitle: true, title: appBarTitle, actions: <Widget>[
       IconButton(
        icon: actionIcon,
        onPressed: () {
          setState(() {

            if (this.actionIcon.icon == Icons.search) {
              this.actionIcon =   Icon(
                Icons.close,
                color: Colors.yellow[800],
              );
              this.appBarTitle =  TextField(
                controller: _searchQuery,
                style:  TextStyle(
                  color: Colors.white,
                ),
                decoration:   InputDecoration(
                    prefixIcon:  Icon(Icons.search, color: Colors.yellow[800]),
                    hintText: "Search...",
                    hintStyle:  TextStyle(color: Colors.yellow[800])),
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
    return
      ListTile(
        //dense: true,
        //tileColor: Colors.red,
        horizontalTitleGap: 8,
        contentPadding: EdgeInsets.symmetric(horizontal:10),
        title: Text(name,style: TextStyle(fontWeight: FontWeight.w400),
        ),
        leading:  const CircleAvatar(
          radius: 20  ,
          backgroundImage:
          AssetImage('images/avatarTMS.png'),
          // NetworkImage(
          //     "https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper.png"),
        ),
      );
      //ListTile(title:  Text(this.name));
  }
}


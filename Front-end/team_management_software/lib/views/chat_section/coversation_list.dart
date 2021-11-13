import 'package:flutter/material.dart';
// import 'package:learning_notifications/constants.dart';
// import 'package:learning_notifications/function_handler.dart';
// import 'package:learning_notifications/sign_in.dart';
// import 'package:learning_notifications/push_notifications.dart';
// import 'package:learning_notifications/shared_pref_functions.dart';
// import 'package:learning_notifications/testing_shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:team_management_software/controller/helper_function.dart';

import '../../change_notifier.dart';
import 'chatting_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
// import 'change_notifier.dart';

// ignore: use_key_in_widget_constructors
class ConversationListPage extends StatefulWidget {
  @override
  _ConversationListPageState createState() => _ConversationListPageState();
}

var thisIsList;

class _ConversationListPageState extends State<ConversationListPage> {
  String? token;
  //bool isLoading = true;
  HelperFunction helperFunction = HelperFunction();
  getConversationList() async {
    thisIsList = context.watch<Data>().listOfTokensNotifier;
  }
  getDeviceToken()async{
 //   token = await FirebaseNotification().getToken();
  }
  updateConversationList()async{
    await context.read<Data>().getTokensDataFromHttp();
  }
  @override
  void initState() {
     getDeviceToken();
     updateConversationList();
    //context.read<Data>().updateTokenListFromSharedPref();
    super.initState();
  }
  @override
  void didChangeDependencies() async{
   await getConversationList();

   //Provider.of<Data>(context, listen: false).getTokensDataFromHttp();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar:AppBar(
         // leadingWidth: 30,
          automaticallyImplyLeading: false,

          title: Text("Conversations",style: TextStyle(color: Colors.yellow[800],fontWeight: FontWeight.w300,fontSize: 25),),
        backgroundColor: Colors.black,
        // actions: [
        //   IconButton(onPressed: (){
        //  // helperFunction.sendNotificationTrial(token, message, name)
        //   //helperFunction.sendDeviceTokenToDatabase();
        //
        // }, icon: const Icon(Icons.logout))],

        ),
        body: thisIsList.isEmpty?Center(child: CircularProgressIndicator(
          color: Colors.yellow[800],
          backgroundColor: Colors.black,
        )): ListView.builder(
          shrinkWrap: true,
          itemCount: thisIsList.length,
          itemBuilder: (context, index) {
            return
              // thisIsList[0]["name"] == null ||thisIsList[index]["token"]==token
              //     ? Container(
              //   child: Text("empty"),
              // )
              //     :
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChattingScreen(
                            thisIsList[index]["token"],
                            thisIsList[index]["fullName"])),
                  );
                },
                child: Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.2,
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Archive',
                      color: Colors.blue,
                      icon: Icons.archive,
                      onTap: () => null,
                    ),
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red[400],
                      icon: Icons.delete,
                      onTap: () {

                      },
                    ),
                  ],


                  child:  Container(
                    padding: EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black12,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: UserTile(thisIsList[index]["fullName"]!,thisIsList[index]["email"])

                ),),
              );
          },
        ),
      ),
    );
  }
}

// ignore: non_constant_identifier_names
UserTile(String name,String email) {
  return
  Container(
     // color: Colors.red,
      padding: const EdgeInsets.only(
        right: 10,
      ),
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 2,
          ),
          const CircleAvatar(
            backgroundImage:
                AssetImage('images/avatarTMS.png'),
            // NetworkImage(
            //     "https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper.png"),
            maxRadius: 22,
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  email,
                  style: TextStyle(fontSize: 11,color: Colors.grey[400],fontWeight: FontWeight.w400),
                ),
                // Text("Online", style: TextStyle(
                //     color: Colors.grey.shade600, fontSize: 13),),
              ],
            ),
          ),
        ],
      ),

  );


}

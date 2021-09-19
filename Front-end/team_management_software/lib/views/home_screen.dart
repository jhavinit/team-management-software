import 'package:flutter/material.dart';
import 'package:team_management_software/views/screens/bottom_navigation.dart';
import 'chat_section/push_notification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var token;
  FirebaseNotification firebaseNotification=FirebaseNotification();

  getDeviceToken()async{
    token= await firebaseNotification.getToken();
    print("token........... $token");
  }
  @override
  void initState() {
    firebaseNotification.initialise(context);
    firebaseNotification.subscribeToTopic("puppy");
    getDeviceToken();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.black,
        title: const Text("Dummy for Initialization"),
        actions: [IconButton(onPressed: () {
    //  Navigator.push(context, MaterialPageRoute(builder: (context)=>ConversationListPage()
         // ChattingScreen("token", "Rohit")
   //   ));
          print("open the chat section");

        }, icon: Icon(Icons.chat))],
      ),
      body: Center(
        child: TextButton(
        child: Text("App Starts here"),
          onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNavigation()));
          },
    ),
      ),
    );
  }
}

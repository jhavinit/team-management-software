import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:learning_notifications/shared_pref_functions.dart';
import 'package:team_management_software/change_notifier.dart';
//import 'package:learning_notifications/testing_shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:team_management_software/controller/shared_prefernce_functions.dart';
import 'package:team_management_software/views/chat_section/chatting_screen.dart';

//after android 8 every notification should be associated with a channel
//we can have multiple channels but every notification should be associated with at least one channel
//it decides the common properties for multiple notifications under this channel
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'high importance notification',
  'This channel is used for imp notification',
  //  groupId: "notification_group"
);

//this handles the notification a like showing and all
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(
      'a background message has arrived....................................................................................................');
  await Firebase.initializeApp();
  print('handling a background: ${message.messageId}');
  print(message.data);
  // Provider.of<Data>(context, listen: false).addToUniqueListFromServer(
  //     message.data["url"],
  //     message.data["type"],
  //     message.data["sendFrom"],
  //     message.data["fileName"] ?? "");
  // var tempList = await SecureStorageFunction.getDataFromSharedPref(message.data["sendFrom"]);
  // if(message.data["type"]=="unsend"){
  //   tempList.removeWhere((element) => element["timeStamp"]==message.data["timeStamp"]);
  //
  // }else{
  //   var newMessage = {"msg": message.data["url"], "by": "notme",
  //     "type": message.data["type"],"fileName": message.data["fileName"],"timeStamp":message.data["timeStamp"]};
  //   tempList.add(newMessage);
  //
  // }
  // await SecureStorageFunction.saveDataToSharedPref(tempList, message.data["sendFrom"]);
}


class FirebaseNotification {
  initialise(context) async {
    await Firebase.initializeApp();
    //handling messages in background

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    var initialisationSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initialisationSettings =
    InitializationSettings(android: initialisationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initialisationSettings);

    FirebaseMessaging.onMessage.listen(
          (RemoteMessage message) async {
        print(
            'a foreground message has arrived....................................................................................................');
       // print("this is message data ${message.data}");

        RemoteNotification? notification = message.notification;
        AndroidNotification? androidNotification =
            message.notification?.android;
        message.notification?.android;
        if (notification != null && androidNotification != null) {
          print("message data ${message.data}");
            print("this is notification body ${notification.body??" "}");


          bool isLoggedIn = await SharedPreferencesFunctions.getIsUserLoggedIn();
         // bool isLoggedIn =true;
          //await SharedPrefFunctions.getIsUserLoggedIn();
          if (isLoggedIn == true) {
            // AndroidNotificationDetails notificationDetails =
            //      AndroidNotificationDetails(
            //          channel.id, channel.name, channel.description,
            //          importance: Importance.max,
            //          priority: Priority.high,
            //          groupKey: channel.groupId);
            //  NotificationDetails notificationDetailsPlatformSpefics =
            //      NotificationDetails(android: notificationDetails);
            //  flutterLocalNotificationsPlugin.show(
            //      notification.hashCode,
            //      notification.title,
            //      notification.body,
            //      notificationDetailsPlatformSpefics);


            flutterLocalNotificationsPlugin.show(
                notification.hashCode,
                notification.title??" ",
                notification.body??" ",

                NotificationDetails(
                    android: AndroidNotificationDetails(
                        channel.id, channel.name, channel.description))
            );
            print("changes reflecting");


            // const snackBar = SnackBar(
            //   content: Text("Sign Up successful"),
            //   duration: Duration(milliseconds: 500),
            //
            // );
            // ScaffoldMessenger.of(context).showSnackBar(snackBar);



              Provider.of<Data>(context, listen: false)
                  .addToUniqueListFromServer(
                message.data["message"] ?? "this is the msg",
                message.data["type"] ?? "text",
                message.data["sendBy"] ?? "noSendBy",
                message.data["fileName"] ?? "noFileName",
                // message.data["timeStamp"]??""
              );


          }
          else print("cannot display notification");
        }

        // List<ActiveNotification>? activeNotifications =
        //     await flutterLocalNotificationsPlugin
        //         .resolvePlatformSpecificImplementation<
        //             AndroidFlutterLocalNotificationsPlugin>()
        //         ?.getActiveNotifications();
        // if (activeNotifications != null) {
        //   if (activeNotifications.length > 0) {
        //     List<String> lines =
        //         activeNotifications.map((e) => e.title.toString()).toList();
        //     InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
        //         lines,
        //         contentTitle: "${activeNotifications.length - 1} messages",
        //         summaryText: "${activeNotifications.length - 1} messages");
        //     AndroidNotificationDetails groupNotificationDetails =
        //         AndroidNotificationDetails(
        //             channel.id, channel.name, channel.description,
        //             styleInformation: inboxStyleInformation,
        //             setAsGroupSummary: true,
        //             groupKey: channel.groupId);
        //
        //     NotificationDetails groupNotificationDetailsPlatformSpefics =
        //         NotificationDetails(android: groupNotificationDetails);
        //     await flutterLocalNotificationsPlugin.show(
        //         0, '', '', groupNotificationDetailsPlatformSpefics);
        // }
        //   }
        if(message.data!=null){
          if(message.data["type"]=="unsend"){
            print("removing a message...............................");
            Provider.of<Data>(context, listen: false).removingMessageFromServer(
              message.data["timeStamp"],
              message.data["sendFrom"],
            );
          }
        }
      },
    );
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("the message is clicked  and message is");
      print(message.data["url"]);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ChattingScreen("token", message.data["sendFrom"]);
      }));
    });
  }

  //to get the token
  Future getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();

    return token;
  }

  //to subscribe to a given topic
  subscribeToTopic(String topic) async {
    print('subscribed');
    await FirebaseMessaging.instance.subscribeToTopic("puppy");
  }

  cancelSubscription(String topic) async {
    print('unsubscribed');
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }

  justANormalNotification() {
    flutterLocalNotificationsPlugin.show(
        0,
        'kuchh v',
        'local hai',
        NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id, channel.name, channel.description)));
  }
}

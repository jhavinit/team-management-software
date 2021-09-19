import 'package:flutter/material.dart';
import 'package:team_management_software/views/chat_section/push_notification.dart';
getAppBar(context,String name){
  FirebaseNotification firebaseNotification=FirebaseNotification();
  return
    AppBar(
      toolbarHeight: 65,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: Container(
          padding: EdgeInsets.only(right: 20, top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              const CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper.png"),
                maxRadius: 20,
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
                      style: const TextStyle(
                          fontSize: 21, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    // Text("Online", style: TextStyle(
                    //     color: Colors.grey.shade600, fontSize: 13),),
                  ],
                ),
              ),
              //focusedMenuToSelectFile(),
              GestureDetector(
                onTap: ()async{
             var token=await    firebaseNotification.getToken();
             print(token);
             },
                child: const Icon(
                  Icons.settings,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
}


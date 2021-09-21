import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:focused_menu/modals.dart';
import 'package:team_management_software/controller/helper_function.dart';
import 'package:team_management_software/controller/shared_prefernce_functions.dart';
import 'package:team_management_software/views/chat_section/audio_section/soundplayer_class.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'package:team_management_software/views/chat_section/pdf_page.dart';
import 'package:team_management_software/views/chat_section/tiles/audio_tile.dart';
import 'package:team_management_software/views/chat_section/tiles/message_tile.dart';
import 'package:team_management_software/views/chat_section/tiles/pdt_tile.dart';
import 'package:team_management_software/views/chat_section/tiles/video_tile.dart';
import 'package:team_management_software/views/components/appbar_chat_screen.dart';
import 'package:team_management_software/views/components/loading_indicator.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
 import '../../change_notifier.dart';
import 'audio_section/sound_recorder_class.dart';
import 'audio_section/sound_recorder_ui.dart';
import 'audio_section/soundplayer_ui.dart';
import 'chewie_player.dart';
import 'pdf_api.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:async/async.dart';
 import 'package:http/http.dart' as http;

 import 'package:path/path.dart' as path;


// ignore: must_be_immutable
class ChattingScreen extends StatefulWidget {
  String? token, name;


  // ignore: use_key_in_widget_constructors
  ChattingScreen(this.token, this.name);
  @override
  _ChattingScreenState createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  String myName=" ";
 final soundRecorder = SoundRecorder();
  final soundPlayer=SoundPlayer();
  Color? myColor = Colors.green;
  bool isSelected = false;
  bool showRecorder = false;
  bool isLoading = true;
  bool toRefresh = false;
  bool alternativeAppbar = true;
 HelperFunction helperFunction = HelperFunction();

  ScrollController scrollController = ScrollController();
  // ignore: prefer_typing_uninitialized_variables
  var messageJsonDataFormUser;
  var listOfMessages=[];
  //final  picker = ImagePicker();

  pickingFile(String extension) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [extension],
        //'jpg', 'pdf', 'doc'
        allowMultiple: false);
    if (result != null) {
      setState(() {
        showSpinner = true;
      });
      PlatformFile file = result.files.first;
      var anyFile = File(file.path!);
      final filename = path.basename(file.path!);

      //await uploadFileToFirebase(anyFile, filename, extension);
      String type;
      if(extension=="jpg"){
        type="image";
      }else if(extension=="mp4"){
        type="video";
      }else if(extension=="mp3"){
        type="audio";
      }
      else{
        type=extension;
      }
      await uploadFileToServer(anyFile,filename,type);
    }
  }

  addingMessageToList(
      String text, String type, String fileName) async {
    if (text != "") {
      context.read<Data>().addToUniqueList({
        "message": text,
        "sendBy": myName,
        "type": type,
        "fileName": fileName,
      }, widget.name!);
    }
  }

  uploadFileToServer(File imageFile,filename,type)async{

      // open a bytestream
      var stream =
       http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      // get file length
      var length = await imageFile.length();

      // string to uri
      var uri = Uri.parse("https://ems-heroku.herokuapp.com/message/uploadingFiles");

      // create multipart request
      var request =  http.MultipartRequest("POST", uri,);

      // multipart that takes file
      var multipartFile =  http.MultipartFile('files', stream, length,
          filename: path.basename(imageFile.path));


      request.files.add(multipartFile);
      request.fields["sender"]=myName;
      request.fields["receiver"]=widget.name!;
      request.fields["fileName"]=filename;
      request.fields["type"]=type;

      // send
      var response = await request.send();
      print(response.statusCode);
      print(response);

      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        var returnedValue=jsonDecode(value);
        print(value+"....................................................");
        var current=returnedValue["newChat"]["message"];
        addingMessageToList(current, type,
            filename);

      });

      setState(() {
        showSpinner = false;
      });
    }






//  String? abc;
  // uploadFileToFirebase(File file, String fileName, String type) async {
  //   if (file != null) {
  //     FirebaseStorage storage = FirebaseStorage.instance;
  //     String newString = fileName.replaceAll(" ", "");
  //     Reference ref = storage.ref().child(newString);
  //     UploadTask uploadTask = ref.putFile(file);
  //     await uploadTask.then((res) async {
  //       abc = await res.ref.getDownloadURL();
  //       print(abc);
  //     });
  //     var timeStamp = DateTime.now().millisecondsSinceEpoch;
  //
  //     if (type == "jpg") addingMessageToList(abc!, "jpg", fileName, timeStamp);
  //     if (type == "pdf") {
  //       addingMessageToList(abc!, "pdf", fileName, timeStamp);
  //     }
  //     if (type == "mp4") {
  //       addingMessageToList(abc!, "video", fileName, timeStamp);
  //     }
  //     if (type == "audio" || type == "mp3") {
  //       print("type audio is getting added");
  //       addingMessageToList(abc!, "audio", fileName, timeStamp);
  //     }
  //
  //     setState(() {
  //       showSpinner = false;
  //     });
  //
  //     // helperFunction.sendNotification(
  //     //     widget.token,
  //     //     abc!,
  //     //     widget.name,
  //     //     type == "jpg"
  //     //         ? "image"
  //     //         : type == "mp4"
  //     //         ? "video"
  //     //         : type == "mp3"
  //     //         ? "audio"
  //     //         : type,
  //     //     fileName,
  //     //     timeStamp.toString());
  //   }
  // }
  updateMessageList()async{
  await  context.read<Data>().updateMessageListFromServer(widget.name!,myName);
  setState(() {
    isLoading = false;
  });
  }
  getUserFromSharedPref()async{
   try {
      myName = await SharedPreferencesFunctions.getUserName();
      print(myName+"mynameeee.....................");
     await updateMessageList();
    }catch(e){
     print(e);
   }
  }
  @override
  void initState() {
    getUserFromSharedPref();
    //updateMessageList();

    context.read<Data>().updateKey(widget.name!);
     soundRecorder.init();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //soundRecorder.dispose();
  }
  @override
  void didChangeDependencies() async{
    listOfMessages = context.watch<Data>().listOfMessagesNotifier;
    super.didChangeDependencies();
  }
  TextEditingController messageController = TextEditingController();
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    bool enableTextField=true;
    String messageType = "text";
    return  Scaffold(
      appBar: getAppBar(context, widget.name!),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        child:isLoading
                            ? Center(
                          //width: 1000,
                            //height: 40,
                            child:Text("loading messages...")
                           // CircularProgressIndicator()
                        )
                            : ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          reverse: true,
                          itemCount: listOfMessages.length,
                          itemBuilder: (context, index) {
                            var length = listOfMessages.length;
                            var currentIndex =
                            listOfMessages[length - index - 1];
                            bool sendByMe = currentIndex["sendBy"] == myName;
                            return
                               Container(
                                 //child:
                                // Text(currentIndex["message"]),
                              padding: EdgeInsets.only(
                                top: 10,
                                left: sendByMe
                                    ? MediaQuery.of(context).size.width /
                                    3
                                    : 10,
                                right: sendByMe
                                    ? 10
                                    : MediaQuery.of(context).size.width /
                                    3,
                              ),
                              alignment: sendByMe
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                               child:
                                 currentIndex["type"] == "text"
                                  ?
                            Container(
                                // color: isSelected?Colors.red:Colors.blue,
                                child:
                           sendByMe?
                            FocusMenuHolderClass(
                                  MessageTile(
                                      text:
                                      currentIndex["message"],
                                      side: sendByMe
                                          ? "left"
                                          : "right"),
                                  length - index - 1,
                                  widget.name!,
                                  currentIndex["timeStamp"]??" ",
                                  widget.token,
                                )
                                    : MessageTile(
                                    text: currentIndex["message"],
                                    side: sendByMe
                                        ? "left"
                                        : "right"),
                             )
                                  : currentIndex["type"] == "jpg" ||
                                  currentIndex["type"] == "image"
                                  ?
                              //lets its a image
                              sendByMe
                                  ? FocusMenuHolderClass(
                                Container(
                                  //this.widget,this.index,this.name,this.timeStamp,this.token
                                  //height: 300,
                                  child: ClipRRect(
                                      borderRadius:
                                      BorderRadius
                                          .circular(10),
                                      child:
                                     //  Image.network(
                                     //    "${currentIndex["message"]}",
                                     //
                                     // ),
                                    FadeInImage.assetNetwork(
                                   //  imageScale: 0.5,
                                      placeholder: 'images/placeholder.jpg', image: "${currentIndex["message"]}",
                                    imageErrorBuilder: (object,_,abc){
                                      return Container(
                                        child:Text("Failed to load image")
                                      );
                                    },)
                                  ),
                                ),
                                length - index - 1,
                                widget.name!,
                                currentIndex["timeStamp"]??" ",
                                widget.token,
                                // helperFunction.sendNotification(widget.token!, "", widget.name!, "unsend", "",
                                // currentIndex["timeStamp"])
                              )
                                  : Container(
                                //height: 300,
                                child: ClipRRect(
                                    borderRadius:
                                    BorderRadius
                                        .circular(10),
                                    child:
                                    FadeInImage.assetNetwork(
                                      //  imageScale: 0.5,
                                      placeholder: 'images/placeholder.jpg', image: "${currentIndex["message"]}",
                                      imageErrorBuilder: (object,_,abc){
                                        return Container(
                                            child:Text("Failed to load image")
                                        );
                                      },)
                                   //  Image.network(
                                   //    "${currentIndex["message"]}",
                                   // )
                              ),
                              )
                                  : currentIndex["type"] == "pdf"
                                  ?
                                 sendByMe?
                              FocusMenuHolderClass(Container(
                                width: 300,
                                height: 100,
                                child: GestureDetector(
                                  onTap: () async {
                                    String url =
                                    currentIndex["message"]!;
                                   final file =
                                    await PDFApi
                                        .loadNetwork(
                                        url);
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                            builder:
                                                (context) {
                                              return PdfScreen(
                                                file: file,
                                                fileName:
                                                currentIndex[
                                                "fileName"]??" ",
                                              );
                                            }));
                                  },
                                  child: PdfTile(
                                      name: currentIndex[
                                      "fileName"]??"fileName",
                                      side: sendByMe
                                          ? "left"
                                          : "right",
                                      url: currentIndex[
                                      "message"]),
                                ),
                              ),
                                length - index - 1,
                                widget.name!,
                                currentIndex["timeStamp"]??" ",
                                widget.token,)
                                  : Container(
                                width: 300,
                                height: 100,
                                child: GestureDetector(
                                  onTap: () async {
                                    String url =
                                    currentIndex["message"]!;
                                    final file =
                                    await PDFApi
                                        .loadNetwork(
                                        url);
                                   Navigator.push(context,
                                        MaterialPageRoute(
                                            builder:
                                                (context) {
                                              return PdfScreen(
                                                file: file,
                                                fileName:
                                                currentIndex[
                                                "fileName"]??"fileName ",
                                              );
                                            }));
                                  },
                                  child: PdfTile(
                                      name: currentIndex[
                                      "fileName"]??"fileName ",
                                      side:sendByMe
                                          ? "left"
                                          : "right",
                                      url: currentIndex[
                                      "message"]),
                                ),
                              )
                                  : currentIndex["type"] ==
                                  "video"
                                  ?sendByMe?FocusMenuHolderClass( GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder:
                                              (context) {
                                            return ChewiePlayer(
                                              videoPlayerController:
                                              VideoPlayerController
                                                  .network(
                                                  currentIndex[
                                                  "message"]!),
                                              fileName:
                                              currentIndex[
                                              "fileName"]??" ",
                                              looping: false,
                                            );
                                          }));
                                },
                                child: Container(
                                  width: 300,
                                  height: 100,
                                  child: VideoTile(
                                      side: sendByMe
                                          ? "left"
                                          : "right",
                                      name: currentIndex[
                                      "fileName"]??" "),
                                ),
                              ),  length - index - 1,
                                widget.name!,
                                currentIndex["timeStamp"]??" ",
                                widget.token,) : GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder:
                                              (context) {
                                            return ChewiePlayer(
                                              videoPlayerController:
                                              VideoPlayerController
                                                  .network(
                                                  currentIndex[
                                                  "message"]!),
                                              fileName:
                                              currentIndex[
                                              "fileName"]??" ",
                                              looping: true,
                                            );
                                          }));
                                },
                                child: Container(
                                  width: 300,
                                  height: 100,
                                  child: VideoTile(
                                      side: sendByMe
                                          ? "left"
                                          : "right",
                                      name: currentIndex[
                                      "fileName"]??" "),
                                ),
                              )
                                  : currentIndex["type"] ==
                                  "audio"
                                  ?sendByMe? FocusMenuHolderClass(GestureDetector(
                                onTap: () {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  showDialog(
                                      context:
                                      context,
                                      builder:
                                          (context) {
                                        return AudioPlayerDialog(
                                          url: currentIndex[
                                          "message"],
                                        );
                                      });
                                },
                                child: Container(
                                    width: 300,
                                    height: 100,
                                    child: AudioTile(
                                        side: sendByMe
                                            ? "left"
                                            : "right",
                                        name: currentIndex[
                                        "fileName"]??" ")),
                              ), length - index - 1,
                                widget.name!,
                                currentIndex["timeStamp"]??" ",
                                widget.token,) : GestureDetector(
                                onTap: () {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  setState(() {
                                    //showSpinner=true;
                                  });
                                  showDialog(
                                      context:
                                      context,
                                      builder:
                                          (context) {
                                        // var isPlaying=soundPlayer.isPlaying;
                                        return AudioPlayerDialog(
                                          url: currentIndex[
                                          "message"],
                                        );
                                      });

                                },
                                child: Container(
                                    width: 300,
                                    height: 100,
                                    child: AudioTile(
                                        side: sendByMe
                                            ? "left"
                                            : "right",
                                        name: currentIndex[
                                        "fileName"]??" ")),
                              )
                                  : Container(),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              showRecorder ? loadingIndicator(context) : Container(),
              Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: TextField(
                          onChanged: (val){

                          },
                          enabled: enableTextField,

                          controller: messageController,
                          decoration: const InputDecoration(
                            hintText: "type your message here",
                          ),
                        )),

                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: () {

                        // setState(() {
                        //   enableTextField=false;
                        // });

                        // showDialog(
                        //     context: context,
                        //     builder: (context) {
                        //       return SoundRecorderWidget(widget.name,widget.token);
                        //     });
                        var width=MediaQuery.of(context).size.width;
                        var snackBar= SnackBar(
                          duration:Duration(milliseconds: 800),
                          behavior: SnackBarBehavior.floating,

                          margin: EdgeInsets.only(left:width/20,
                            right: width/2.5,
                            bottom: width/8,

                          ),

                          content: Text("Long press to start recording"),backgroundColor: Colors.black,);
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      },
                      onLongPressStart: (val)async {
                        await soundRecorder.openingSession();
                        setState(() {
                          showRecorder = true;
                        });

                        soundRecorder.toggleRecording();
                      },
                      onLongPressEnd: (val) {
                        setState(() {
                          showRecorder = false;
                          soundRecorder.toggleRecording();
                        });

                        showDialog(context: context, builder: (context){
                          return SoundRecorderWidget(widget.name,widget.token);
                        });
                      },
                      child: Container(
                        child: Icon(
                          Icons.mic_none_outlined,
                          size: 30,
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(

                      onSelected: (String value) {

                        if (value == "image") {
                          pickingFile("jpg");
                          messageType = "jpg";
                        } else if (value == "pdf") {
                          pickingFile("pdf");
                          messageType = "pdf";
                        } else if (value == "video") {
                          pickingFile("mp4");
                          messageType = "video";
                        } else if (value == "audio") {
                          pickingFile("mp3");
                          messageType = "audio";
                        }
                      },
                      icon: const Icon(
                        Icons.attach_file_outlined,
                        size: 30,
                      ),
                      itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'image',
                          child: Text('image'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'video',
                          child: Text('video'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'pdf',
                          child: Text('pdf file'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'audio',
                          child: Text('audio'),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.teal[400],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: RawMaterialButton(
                        onPressed: () {
                          String text = messageController.text;
                          var timeStamp =
                              DateTime.now().millisecondsSinceEpoch;
                          addingMessageToList(
                              text, messageType, " ");
                          messageController.text = "";

                          setState(() {});
                          scrollController.animateTo(0.0,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeIn);

                          if(text!="") {
                            helperFunction.sendNotificationTrial(myName,widget.name,text);
                          }
                         // print("sent");
                           //saveDataToSharedPrefs();
                        },
                        child: const Text(
                          "Send",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        //fillColor: Colors.teal[200],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  toggleSelection() {
    setState(() {
      if (isSelected) {
        myColor = Colors.white;
        isSelected = false;
      } else {
        myColor = Colors.grey[300];
        isSelected = true;
      }
    });
  }
}

class FocusMenuHolderClass extends StatelessWidget {
  final Widget widget;
  final String name;
  final int index;
  final timeStamp;
  final token;
// final Future function;
  FocusMenuHolderClass(
      this.widget, this.index, this.name, this.timeStamp, this.token);
  // HelperFunction helperFunction = HelperFunction();

  @override
  Widget build(
      BuildContext context,
      ) {
    return FocusedMenuHolder(
        menuWidth: 100,
        onPressed: () {},
        menuItems: [
          FocusedMenuItem(
            title: const Text(
              "Unsend",
              style: TextStyle(fontSize: 15),
            ),
            onPressed: () {
              // context.read<Data>().removingMessage(index, name);
              // print("this is from the function handler");
              // print(" $token $name $timeStamp");
              // helperFunction.sendNotification(
              //     token, "", name, "unsend", "", timeStamp);
//String? token,String? message,String? name,String type,String fileName, timeStamp
            },
          ),
        ],
        openWithTap: false,
        blurSize: 2,
        child: widget);
  }
}

focusedMenuToSelectFile(){
  return FocusedMenuHolder(
    child: Icon(Icons.attach_file_rounded,size: 30,),
    openWithTap: true,
    menuWidth :200,
    onPressed: (){

    },
    menuItems: [FocusedMenuItem(title: Text("hi"), onPressed: (){

    }),
      FocusedMenuItem(title: Text("hello"), onPressed: (){

      })],
  );
}
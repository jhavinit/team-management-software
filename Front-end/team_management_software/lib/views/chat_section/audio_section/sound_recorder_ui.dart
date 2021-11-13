import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:team_management_software/views/components/loading_indicator.dart';
import 'soundplayer_class.dart';
import 'sound_recorder_class.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
//import 'package:provider/src/provider.dart';
import 'package:provider/provider.dart';
import 'package:team_management_software/change_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:path/path.dart' as path;


class SoundRecorderWidget extends StatefulWidget {
  final name;
  final token;
  SoundRecorderWidget(this.name, this.token);
  @override
  _SoundRecorderWidgetState createState() => _SoundRecorderWidgetState();
}

class _SoundRecorderWidgetState extends State<SoundRecorderWidget> {
  // final helperFunction=HelperFunction();
  bool isLoading = false;
  bool isPlaying = false;
  SoundPlayer soundPlayer = SoundPlayer();
  SoundRecorder soundRecorder = SoundRecorder();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    soundPlayer.init();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    soundPlayer.dispose();
  }

  uploadFileToFirebase() async {
    setState(() {
      isLoading = true;
    });
    print("uploading is called");
    final file = File(tempPath!);

    if (file != null) {
       FirebaseStorage storage = FirebaseStorage.instance;
       var timeStamp = DateTime.now().millisecondsSinceEpoch;
      Reference ref = storage.ref().child(timeStamp.toString());
      UploadTask uploadTask = ref.putFile(file);
      await uploadTask.then((res) async {
        var abc = await res.ref.getDownloadURL();
        print(abc);


        // context.read<Data>().addToUniqueList({
        //   "msg": "abc",
        //   "by": "me",
        //   "type": "audio",
        //   "fileName": "AUD-" + timeStamp.toString(),
        //   "timeStamp": timeStamp.toString()
        // }, widget.name);
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
      });} else {
      print("the file is not getting uploaded");
    }
  }
  addingMessageToList(
      String text, String type, String fileName) async {
    if (text != "") {
      context.read<Data>().addToUniqueList({
        "message": text,
        "sendBy": "myName",
        "type": type,
        "fileName": fileName,
      }, widget.name!);
    }
  }



  uploadFileToServer()async{
    setState(() {
      isLoading = true;
    });
    print("uploading is called");
    final imageFile = File(tempPath!);
    var timeStamp = DateTime.now().millisecondsSinceEpoch;
    var filename="AUD"+timeStamp.toString();

    // open a byte stream
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
    request.fields["sender"]=widget.name!;
    request.fields["receiver"]=widget.name!;
    request.fields["fileName"]=filename;
    request.fields["type"]="audio";


    request.files.add( multipartFile);


    // send
    var response = await request.send();
    print(response.statusCode);
    print(response);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      var returnedValue=jsonDecode(value);
      print(value+"....................................................");
      var current=returnedValue["newChat"]["message"];
      addingMessageToList(current, "audio",
          filename);

    });
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);


  }






  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.only(top: 30, bottom: 30),
            decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                isPlaying ? loadingIndicator(context) : Container(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        soundPlayer.play(() {
                          setState(() {
                            isPlaying = !isPlaying;
                          });
                        }, "temp");
                        setState(() {
                          isPlaying = !isPlaying;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white54,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        //width: 150,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.play_arrow,
                              size: 30,
                            ),
                            Text(
                              "Play Recorded Audio",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await uploadFileToServer();
                      },
                      child: Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),

                                //width: 150,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Discard",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(Icons.cancel),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Confirm send",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(Icons.send)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}

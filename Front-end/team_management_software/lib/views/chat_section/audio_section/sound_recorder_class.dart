import 'dart:io';

import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
//import 'package:learning_notifications/function_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:path/path.dart';

//final pathToSaveAudio ="audio_example.aac";

//String? tempName;

var tempPath;

class SoundRecorder{
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecorderInitialised =false;

  bool get isRecording=> _audioRecorder!.isRecording;

  Future init()async{
    var dir=await getApplicationDocumentsDirectory();
    tempPath='${dir.path}/audio_testing';
    print("the temp path is $tempPath");
    _audioRecorder=  FlutterSoundRecorder();
    final status=await Permission.microphone.request();
    if(status!=PermissionStatus.granted){
      throw RecordingPermissionException("Microphone permission not given");
    }
    // await _audioRecorder!.openAudioSession();
    // _isRecorderInitialised=true;
  }
  openingSession()async{
    await _audioRecorder!.openAudioSession();
    _isRecorderInitialised=true;
  }

  Future dispose()async{
    await _audioRecorder!.closeAudioSession();
    _audioRecorder=null;
    _isRecorderInitialised=false;
  }
  Future _record() async{
    if(!_isRecorderInitialised)return;
    try{
      final dir = await getApplicationDocumentsDirectory();
      tempPath='${dir.path}/audio_testing';
      //tempName="trying_a_name.aac";
      await _audioRecorder!.startRecorder(toFile: tempPath,
          codec: Codec.defaultCodec);
    }catch(e){
      print("from _record");
      print(e.toString());
    }
  }
  Future _stop()async{
    if(!_isRecorderInitialised)return;
    try {

      await _audioRecorder!.stopRecorder();
      // uploadFileToFirebase();

    }catch(e){
      print("from _stop");
      print(e.toString());
    }
  }
  Future toggleRecording()async{
    if(!_isRecorderInitialised)return;
    //print("this part is executed");
    if(_audioRecorder!.isStopped){
      await _record();
    }else {
      await _stop();
    }
  }

}


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';
//import 'package:learning_notifications/audio_player/sound_recorder.dart';
import 'sound_recorder_class.dart';
class SoundPlayer{
  FlutterSoundPlayer? _audioPlayer;

  bool get isPlaying=>_audioPlayer!.isPlaying;

  Future init()async{
    _audioPlayer=FlutterSoundPlayer();
    await _audioPlayer!.openAudioSession();
    // _audioPlayer!.onProgress!.listen((event) {
    //   print("the audio is playing and event is $event............................................................................................................................");
    // });

  }
  void dispose(){
    _audioPlayer!.closeAudioSession();
    _audioPlayer=null;
  }

  Future play(VoidCallback whenFinished,String url)async{
    try{
      await _audioPlayer!.startPlayer(

        fromURI:url=="temp"?tempPath:url,
        //url,
        //"https://firebasestorage.googleapis.com/v0/b/notification-eef81.appspot.com/o/recorded_file?alt=media&token=2ce62e6c-e904-41f1-83b4-e46a4e16d267",
        whenFinished: whenFinished,
      );

    }catch(e){
      print(e.toString());
    }


  }

  Future stop()async{
    await _audioPlayer!.stopPlayer();
  }
  Future pause()async{
    await _audioPlayer!.pausePlayer();
  }
  Future resume()async{
    await _audioPlayer!.resumePlayer();
  }

  Future togglePlaying()async{
    if(_audioPlayer!.isPaused){
      await resume();
    }else{
      await pause();
    }
  }

}

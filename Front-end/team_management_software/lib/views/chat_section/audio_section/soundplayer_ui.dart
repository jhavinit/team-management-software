import 'package:flutter/material.dart';
import 'package:team_management_software/views/components/loading_indicator.dart';
// import 'package:learning_notifications/audio_player/sound_player.dart';
import 'soundplayer_class.dart';
class AudioPlayerDialog extends StatefulWidget {
  final url;
  const AudioPlayerDialog({Key? key,required this.url}) : super(key: key);

  @override
  _AudioPlayerDialogState createState() => _AudioPlayerDialogState();
}

class _AudioPlayerDialogState extends State<AudioPlayerDialog> {
  var isPlaying=true;
  final soundPlayer=SoundPlayer();
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
  @override
  void didChangeDependencies() async{
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    await  soundPlayer.play(() {
      Navigator.pop(context);
    }, widget.url);
  }

  @override
  Widget build(BuildContext context)  {
   // print("the url received is ${widget.url}");

    return
      Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.all( Radius.circular(20))
            ),
            //   color: Colors.white10,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                isPlaying? loadingIndicator(context):Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    ElevatedButton.icon(
                        onPressed: () async {
                          await soundPlayer.togglePlaying();

                          setState(() {
                            isPlaying=soundPlayer.isPlaying;
                          });
                        },
                        icon: Icon( isPlaying?Icons.pause:Icons.play_arrow),
                        label: Text(
                          isPlaying?"pause":"play",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                    SizedBox(width: 20,),
                    ElevatedButton.icon(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        icon: Icon( Icons.stop),
                        label: Text(
                          "Stop",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ],
            ),
          )

      );
  }
}

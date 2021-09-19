import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class ChewiePlayer extends StatefulWidget {
  final VideoPlayerController? videoPlayerController;
  final bool? looping;
  final String? fileName;
  ChewiePlayer({
    this.videoPlayerController,
    this.looping,
    this.fileName
  });

  @override
  _ChewiePlayerState createState() => _ChewiePlayerState();
}

class _ChewiePlayerState extends State<ChewiePlayer> {
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    chewieController=ChewieController(
        videoPlayerController:
        widget.videoPlayerController!,
        aspectRatio: 16/9,
        autoInitialize: true,
        looping: widget.looping??true,
        errorBuilder: (context,errorMessage){
          return Center(
            child: Text(errorMessage,
              style: TextStyle(color: Colors.white),),
          );
        }

    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.fileName??"Video"),),
      body: Chewie(
        controller: chewieController!,
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.videoPlayerController!.dispose();
    chewieController!.dispose();
  }
}

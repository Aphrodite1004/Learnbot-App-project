import 'dart:io';

import 'package:flutter/material.dart';
import 'package:leanrbot/component/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';



class DisplayVideo extends StatefulWidget {
  String video_path;
  String image_path;
  String titles;
  DisplayVideo(this.video_path, this.image_path, this.titles);

  @override
  _DisplayVideo createState() => _DisplayVideo();
}

class _DisplayVideo extends State<DisplayVideo> {

  VideoPlayerController _controller;

  bool play_video = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.file(File(widget.video_path))..initialize().then((_) {
      setState(() {
        _controller.play();
      });
    });
    _controller.addListener(() {
      if(_controller.value.duration.inSeconds == _controller.value.position.inSeconds){
        setState(() {
          play_video = false;
        });
      }

    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
      appBar:  AppBar(
        title: Text(widget.titles),
        centerTitle: true,
        backgroundColor: colorStyle.primaryColor,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child:play_video? VideoPlayer(_controller):Image.file(
          File(widget.image_path),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

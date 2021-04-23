import 'package:leanrbot/component/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Settings2 extends StatefulWidget {
  @override
  _Settings2 createState() => _Settings2();
}

class _Settings2 extends State<Settings2> {
  VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.asset("assets/guide.mp4")
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
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
    MediaQueryData mediaquery = MediaQuery.of(context);
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(color: colorStyle.primaryColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: mediaquery.padding.top + 10,
            ),
            Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'How the app works',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  alignment: Alignment.center,
                ),
                Positioned(
                  right: 10,
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: RawMaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.transparent,
                        child: Image.asset(
                          'assets/images/assets_icons_prev.png',
                          width: 40,
                        ),
                      ),
                      shape: CircleBorder(),
                      elevation: 2.0,
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        padding: EdgeInsets.all(10),
                        child: _controller.value.initialized
                            ? AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: VideoPlayer(_controller),
                              )
                            : Container(),
                      ),
                      Stack(
                        children: <Widget>[
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 50),
                            reverseDuration: Duration(milliseconds: 200),
                            child: _controller.value.isPlaying
                                ? SizedBox.shrink()
                                : Container(
                                    color: Colors.transparent,
                                    child: Center(
                                      child:Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black.withOpacity(0.2)
                                        ),
                                        child:  Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                          size: 100.0,
                                        ),
                                      )
                                    ),
                                  ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _controller.value.isPlaying
                                  ? _controller.pause()
                                  : _controller.play();
                              setState(() {

                              });
                            },
                          ),
                        ],
                      ),
                      VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}

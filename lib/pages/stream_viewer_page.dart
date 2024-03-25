import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class StreamViewerPage extends StatefulWidget {
  //final String streamID;

  VlcPlayerController controller;

  StreamViewerPage({super.key, required this.controller});

  @override
  _StreamViewerPageState createState() => _StreamViewerPageState();
}

class _StreamViewerPageState extends State<StreamViewerPage> {
  /*void initializePlayer() {
    videoPlayerController = VlcPlayerController.network(
      widget.streamID,
      hwAcc: HwAcc.auto,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
  }*/

  @override
  void initState() {
    //_videoPlayerController = 'rtmp://79.174.95.191:1935/${widget.streamID}/live';
    super.initState();
    /*videoPlayerController = VlcPlayerController.network(
      widget.streamID,
      hwAcc: HwAcc.auto,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
    videoPlayerController.addOnInitListener(() async {
      await videoPlayerController.startRendererScanning();
    });
    videoPlayerController.addOnRendererEventListener((type, id, name) {
      debugPrint('OnRendererEventListener $type $id $name');
    });*/
  }

  @override
  void dispose() async {
    super.dispose();
    await widget.controller.stopRendererScanning();
    await widget.controller.dispose();
    //await _videoViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Transform.scale(
              scale: 1.2,
              child: VlcPlayer(
                controller: widget.controller,
                aspectRatio: 9 / 16,
                placeholder: Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
        )
        /*FutureBuilder(
            future: initializePlayer(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.done) {
                return Center(
                  child: Transform.scale(
                    scale: 1.3,
                    child: VlcPlayer(
                      controller: videoPlayerController,
                      aspectRatio: 9 / 16,
                      placeholder: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }) */
        );
  }
}

import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:haishin_kit/audio_source.dart';
import 'package:haishin_kit/stream_view_texture.dart';
import 'package:haishin_kit/rtmp_connection.dart';
import 'package:haishin_kit/rtmp_stream.dart';
import 'package:haishin_kit/video_settings.dart';
import 'package:haishin_kit/video_source.dart';
import 'package:permission_handler/permission_handler.dart';

class StreamVideoPage extends StatefulWidget {
  const StreamVideoPage({Key? key, required this.streamID}) : super(key: key);

  final String streamID;

  @override
  State<StreamVideoPage> createState() => _StreamVideoPageState();
}

class _StreamVideoPageState extends State<StreamVideoPage> {
  RtmpConnection? _connection;
  RtmpStream? _stream;
  bool _recording = false;
  CameraPosition currentPosition = CameraPosition.back;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    await Permission.camera.request();
    await Permission.microphone.request();

    // Set up AVAudioSession for iOS.
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth,
    ));

    RtmpConnection connection = await RtmpConnection.create();
    connection.eventChannel.receiveBroadcastStream().listen((event) {
      switch (event["data"]["code"]) {
        case 'NetConnection.Connect.Success':
          _stream?.publish("live");
          setState(() {
            _recording = true;
          });
          break;
      }
    });
    RtmpStream stream = await RtmpStream.create(connection);
    stream.videoSettings =
        VideoSettings(width: 720, height: 1080, bitrate: 3500 * 1000);
    stream.attachAudio(AudioSource());
    stream.attachVideo(VideoSource(position: currentPosition));

    if (!mounted) return;

    setState(() {
      _connection = connection;
      _stream = stream;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // Handle this case
        break;
      case AppLifecycleState.inactive:
        _connection?.close();
        // Handle this case
        break;
      case AppLifecycleState.paused:
        _connection?.close();
        // Handle this case
        break;
      case AppLifecycleState.detached:
        _connection?.close();
        // Handle this case
        break;
      case AppLifecycleState.hidden:
        _connection?.close();
    }
  }

  @override
  void dispose() async {
    super.dispose();
    _connection?.close();
    _recording = false;
    //await _videoViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.grey.shade900,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.flip_camera_android,
                color: Colors.white,
              ),
              onPressed: () {
                if (currentPosition == CameraPosition.front) {
                  currentPosition = CameraPosition.back;
                } else {
                  currentPosition = CameraPosition.front;
                }
                _stream?.attachVideo(VideoSource(position: currentPosition));
              },
            )
          ]),
      body: Center(
        child: _stream == null ? const Text("") : StreamViewTexture(_stream),
      ),
      floatingActionButton: FloatingActionButton(
        child: _recording
            ? const Icon(Icons.fiber_smart_record)
            : const Icon(Icons.not_started),
        onPressed: () {
          if (_recording) {
            _connection?.close();
            setState(() {
              _recording = false;
            });
          } else {
            _connection?.connect("rtmp://79.174.95.191/${widget.streamID}");
          }
        },
      ),
    );
  }
}

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_ui/shared/model/track.dart';

class TrackListTile extends StatefulWidget {
  TrackListTile(
    this.track, {
    Key key,
  }) : super(key: key);

  final Track track;

  @override
  _TrackListTileState createState() => _TrackListTileState();
}

class _TrackListTileState extends State<TrackListTile> {
  AudioPlayerState audioPlayerState;

  AudioPlayer _audioPlayer;
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _subscription = _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        audioPlayerState = state;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
    disposeAudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        icon: Icon(_getIconDataByAudioPlayerState()),
        onPressed: () => onAudioPreviewButtonPressed(widget.track.previewUrl),
      ),
      title: Text(widget.track.title),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(widget.track.length.toString().split('.').first.padLeft(8, "0"))
        ],
      ),
    );
  }

  IconData _getIconDataByAudioPlayerState() {
    return audioPlayerState == AudioPlayerState.PLAYING
        ? Icons.pause_circle_outline
        : Icons.play_circle_outline;
  }

  void onAudioPreviewButtonPressed(String previewUrl) async {
    switch (audioPlayerState) {
      case AudioPlayerState.PLAYING:
        await _audioPlayer.pause();
        break;
      case AudioPlayerState.STOPPED:
        await _audioPlayer.resume();
        break;
      case AudioPlayerState.PAUSED:
        await _audioPlayer.resume();
        break;
      case AudioPlayerState.COMPLETED:
        await _audioPlayer.release();
        await _audioPlayer.play(previewUrl);
        break;
      default:
        await _audioPlayer.play(previewUrl);
        break;
    }
  }

  void disposeAudioPlayer() async {
    await _audioPlayer.stop();
    await _audioPlayer.release();
    await _audioPlayer.dispose();
  }
}

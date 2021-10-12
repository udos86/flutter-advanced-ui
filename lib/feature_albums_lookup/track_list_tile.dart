import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_ui/shared/model/track.dart';

class TrackListTile extends StatefulWidget {
  const TrackListTile(
    this.track, {
    Key? key,
  }) : super(key: key);

  final Track track;

  @override
  _TrackListTileState createState() => _TrackListTileState();
}

class _TrackListTileState extends State<TrackListTile> {
  PlayerState? playerState;

  late AudioPlayer _audioPlayer;
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _subscription = _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        playerState = state;
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
      leading: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          StreamBuilder<Duration>(
            stream: _audioPlayer.onDurationChanged,
            builder: (context, snapshot) {
              final duration = snapshot.data?.inSeconds;
              return StreamBuilder<Duration>(
                stream: _audioPlayer.onAudioPositionChanged,
                builder: (context, snapshot) {
                  final position = snapshot.data?.inSeconds;
                  return CircularProgressIndicator(
                    backgroundColor: Colors.black26,
                    strokeWidth: 2,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.black87),
                    value: _getProgressValue(position, duration),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(_getIconDataByAudioPlayerState()),
            onPressed: () {
              onAudioPreviewButtonPressed(widget.track.previewUrl);
            },
          ),
        ],
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

  double _getProgressValue(int? position, int? duration) {
    if (position != null && duration != null) {
      final progress = position / duration.toDouble();
      if (progress < 1.0) {
        return progress;
      }
    }

    return 0.0;
  }

  IconData _getIconDataByAudioPlayerState() {
    return playerState == PlayerState.PLAYING ? Icons.pause : Icons.play_arrow;
  }

  void onAudioPreviewButtonPressed(String previewUrl) async {
    switch (playerState) {
      case PlayerState.PLAYING:
        await _audioPlayer.pause();
        break;
      case PlayerState.STOPPED:
        await _audioPlayer.resume();
        break;
      case PlayerState.PAUSED:
        await _audioPlayer.resume();
        break;
      case PlayerState.COMPLETED:
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

import 'package:flutter/material.dart';
import 'package:flutter_advanced_ui/shared/model/album.dart';
import 'package:flutter_advanced_ui/shared/model/track.dart';

abstract class MusicDataState {
  const MusicDataState();
}

class DataEmpty extends MusicDataState {}

class DataError extends MusicDataState {
  final String message;

  const DataError({
    this.message,
  });
}

class DataLoading extends MusicDataState {}

class AlbumsLoaded extends MusicDataState {
  final List<Album> albums;

  const AlbumsLoaded({
    @required this.albums,
  }) : assert(albums != null);
}

class TracksLoaded extends MusicDataState {
  final List<Track> tracks;

  const TracksLoaded({
    @required this.tracks,
  }) : assert(tracks != null);
}

import 'package:flutter/material.dart';

abstract class MusicDataEvent {
  const MusicDataEvent();
}

class SearchAlbums extends MusicDataEvent {
  final String term;

  const SearchAlbums({
    @required this.term,
  }) : assert(term != null);
}

class FetchTracks extends MusicDataEvent {
  final String albumId;

  const FetchTracks({
    @required this.albumId,
  }) : assert(albumId != null);
}

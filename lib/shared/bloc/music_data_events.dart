import 'package:flutter/material.dart';

abstract class MusicDataEvent {
  const MusicDataEvent();
}

class SearchArtists extends MusicDataEvent {
  final String term;

  const SearchArtists({
    @required this.term,
  }) : assert(term != null);
}

class LookupAlbums extends MusicDataEvent {
  final String artistId;

  const LookupAlbums({
    @required this.artistId,
  }) : assert(artistId != null);
}

class LookupTracks extends MusicDataEvent {
  final String albumId;

  const LookupTracks({
    @required this.albumId,
  }) : assert(albumId != null);
}

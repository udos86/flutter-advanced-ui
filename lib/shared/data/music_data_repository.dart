import 'package:flutter/material.dart';
import 'package:flutter_advanced_ui/shared/data/music_data_provider.dart';
import 'package:flutter_advanced_ui/shared/model/album.dart';
import 'package:flutter_advanced_ui/shared/model/artist.dart';
import 'package:flutter_advanced_ui/shared/model/track.dart';

class MusicDataRepository {
  final MusicDataProvider provider;

  MusicDataRepository({
    @required this.provider,
  }) : assert(provider != null);

  Future<List<Album>> getAlbums(String artistId) async {
    return await provider.fetchAlbumsByArtist(artistId);
  }

  Future<List<Artist>> getArtists(String term) async {
    return await provider.fetchArtists(term);
  }

  Future<List<Track>> getTracks(String albumId) async {
    return await provider.fetchTracksByAlbum(albumId);
  }
}

import 'package:flutter_advanced_ui/shared/data/music_data_cache.dart';
import 'package:flutter_advanced_ui/shared/data/music_data_provider.dart';
import 'package:flutter_advanced_ui/shared/model/album.dart';
import 'package:flutter_advanced_ui/shared/model/artist.dart';
import 'package:flutter_advanced_ui/shared/model/track.dart';

class MusicDataRepository {
  final MusicDataCache cache;
  final MusicDataProvider provider;

  MusicDataRepository({
    MusicDataCache? cache,
    required this.provider,
  }) : cache = cache ?? MusicDataCache();

  Future<List<Album>> getAlbumsByArtist(String artistId) async {
    return cache.get<Album>(artistId) ??
        await _fetchAndCache<Album>(
            artistId, provider.fetchAlbumsByArtist(artistId));
  }

  Future<List<Artist>> getArtists(String query) async {
    return cache.get<Artist>(query) ??
        await _fetchAndCache<Artist>(query, provider.fetchArtists(query));
  }

  Future<List<Track>> getTracksByAlbum(String albumId) async {
    return cache.get<Track>(albumId) ??
        await _fetchAndCache<Track>(
            albumId, provider.fetchTracksByAlbum(albumId));
  }

  Future<List<T>> _fetchAndCache<T>(String key, Future<List<T>> fetch) async {
    final data = await fetch;
    cache.set(key, data);

    return data;
  }
}

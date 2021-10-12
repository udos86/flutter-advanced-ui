import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_advanced_ui/shared/model/album.dart';
import 'package:flutter_advanced_ui/shared/model/artist.dart';
import 'package:flutter_advanced_ui/shared/model/track.dart';

class MusicDataProvider {
  static const searchBaseUrl = 'https://itunes.apple.com/search';
  static const lookupBaseUrl = 'https://itunes.apple.com/lookup';

  final http.Client httpClient;

  MusicDataProvider({
    required this.httpClient,
  });

  Future<List<Artist>> fetchArtists(String artistTerm) async {
    final term = artistTerm.toLowerCase().replaceAll(' ', '+');
    final queryParams = 'term=$term&entity=musicArtist&attribute=artistTerm';
    final url = '$searchBaseUrl?$queryParams';
    final payload = await _get(url);

    final artists = List.generate(payload['resultCount'], (index) {
      return Artist.fromJson(payload['results'][index]);
    });

    return artists;
  }

  Future<List<Album>> fetchAlbumsByArtist(String artistId) async {
    final queryParams = 'id=$artistId&entity=album';
    final url = '$lookupBaseUrl?$queryParams';
    final payload = await _get(url);

    final albums = (payload['results'] as List)
        .where((result) => result['wrapperType'] == 'collection')
        .map((result) => Album.fromJson(result))
        .toList();

    return albums;
  }

  Future<List<Track>> fetchTracksByAlbum(String albumId) async {
    final queryParams = 'id=$albumId&entity=song';
    final url = '$lookupBaseUrl?$queryParams';
    final payload = await _get(url);

    final tracks = (payload['results'] as List)
        .where((result) => result['wrapperType'] == 'track')
        .map((result) => Track.fromJson(result))
        .toList();

    return tracks;
  }

  dynamic _get(String url) async {
    debugPrint('Http get: $url');
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == HttpStatus.ok) {
      return await json.decode(response.body);
    } else {
      throw Exception('Could not get $url');
    }
  }
}

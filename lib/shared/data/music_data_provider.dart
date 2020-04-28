import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_ui/shared/model/album.dart';
import 'package:flutter_advanced_ui/shared/model/track.dart';
import 'package:http/http.dart' as http;

class MusicDataProvider {
  static const searchBaseUrl = 'https://itunes.apple.com/search';
  static const lookupBaseUrl = 'https://itunes.apple.com/lookup';

  final http.Client httpClient;

  MusicDataProvider({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<Album>> fetchAlbums(String term) async {
    final queryParams = 'term=${term.toLowerCase()}&entity=album';
    final url = '$searchBaseUrl?$queryParams';
    final response = await http.get(url);

    if (response.statusCode == HttpStatus.ok) {
      final payload = await json.decode(response.body);
      final albums = List.generate(payload['resultCount'], (index) {
        return Album.fromJson(payload['results'][index]);
      });

      return albums;
    } else {
      throw Exception('Oops, something went wrong');
    }
  }

  Future<List<Track>> fetchTracks(String albumId) async {
    final queryParams = 'id=$albumId&entity=song';
    final url = '$lookupBaseUrl?$queryParams';
    final response = await http.get(url);

    if (response.statusCode == HttpStatus.ok) {
      final payload = await json.decode(response.body);
      final tracks = (payload['results'] as List)
          .where((result) => result['wrapperType'] == 'track')
          .map((result) => Track.fromJson(result))
          .toList();

      return tracks;
    } else {
      throw Exception('Oops, something went wrong');
    }
  }
}

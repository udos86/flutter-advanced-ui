import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';

import 'package:flutter_advanced_ui/shared/data/music_data_repository.dart';
import 'package:flutter_advanced_ui/shared/model/album.dart';

import 'music_data_states.dart';

class LookupAlbums {
  final String artistId;

  const LookupAlbums({
    @required this.artistId,
  }) : assert(artistId != null);
}

class AlbumsLoaded extends MusicDataState {
  final List<Album> albums;

  const AlbumsLoaded({
    @required this.albums,
  }) : assert(albums != null);
}

class MusicAlbumsLookupBloc extends Bloc<LookupAlbums, MusicDataState> {
  final MusicDataRepository repository;

  MusicAlbumsLookupBloc({
    @required this.repository,
  }) : assert(repository != null);

  @override
  MusicDataState get initialState => DataEmpty();

  @override
  Stream<MusicDataState> mapEventToState(LookupAlbums event) async* {
    yield DataLoading();
    try {
      if (event is LookupAlbums) {
        final albums = await repository.getAlbums(event.artistId);
        yield AlbumsLoaded(albums: albums);
      }
    } catch (_error) {
      yield DataError();
    }
  }
}

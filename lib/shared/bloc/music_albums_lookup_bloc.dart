import 'package:bloc/bloc.dart';

import 'package:flutter_advanced_ui/shared/data/music_data_repository.dart';
import 'package:flutter_advanced_ui/shared/model/album.dart';

import 'music_data_states.dart';

class LookupAlbums {
  final String artistId;

  const LookupAlbums({
    required this.artistId,
  });
}

class AlbumsLoaded extends MusicDataState {
  final List<Album> albums;

  const AlbumsLoaded({
    required this.albums,
  });
}

class MusicAlbumsLookupBloc extends Bloc<LookupAlbums, MusicDataState> {
  final MusicDataRepository repository;

  MusicAlbumsLookupBloc({
    required this.repository,
  }) : super(DataEmpty());

  @override
  Stream<MusicDataState> mapEventToState(LookupAlbums event) async* {
    yield DataLoading();
    try {
      if (event is LookupAlbums) {
        final albums = await repository.getAlbumsByArtist(event.artistId);
        yield AlbumsLoaded(albums: albums);
      }
    } catch (_error) {
      yield const DataError('Error');
    }
  }
}

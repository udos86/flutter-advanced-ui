import 'package:bloc/bloc.dart';

import 'package:flutter_advanced_ui/shared/data/music_data_repository.dart';
import 'package:flutter_advanced_ui/shared/model/artist.dart';

import 'music_data_states.dart';

class SearchArtists {
  final String term;

  const SearchArtists({
    required this.term,
  });
}

class ArtistsLoaded extends MusicDataState {
  final List<Artist> artists;

  const ArtistsLoaded({
    required this.artists,
  });
}

class MusicArtistsSearchBloc extends Bloc<SearchArtists, MusicDataState> {
  final MusicDataRepository repository;

  MusicArtistsSearchBloc({
    required this.repository,
  }) : super(DataEmpty());

  @override
  Stream<MusicDataState> mapEventToState(SearchArtists event) async* {
    yield DataLoading();
    try {
      if (event is SearchArtists) {
        final artists = await repository.getArtists(event.term);
        yield ArtistsLoaded(artists: artists);
      }
    } catch (_error) {
      yield const DataError('Error');
    }
  }
}

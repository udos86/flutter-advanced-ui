import 'package:flutter/material.dart';
import 'package:flutter_advanced_ui/shared/bloc/music_data_events.dart';
import 'package:flutter_advanced_ui/shared/data/music_data_repository.dart';
import 'package:flutter_advanced_ui/shared/bloc/music_data_states.dart';
import 'package:bloc/bloc.dart';

class MusicSearchBloc extends Bloc<MusicDataEvent, MusicDataState> {
  final MusicDataRepository repository;

  MusicSearchBloc({
    @required this.repository,
  }) : assert(repository != null);

  @override
  MusicDataState get initialState => DataEmpty();

  @override
  Stream<MusicDataState> mapEventToState(MusicDataEvent event) async* {
    yield DataLoading();
    try {
      if (event is SearchArtists) {
        final artists = await repository.getArtists(event.term);
        yield ArtistsLoaded(artists: artists);
      }
    } catch (_error) {
      yield DataError();
    }
  }
}

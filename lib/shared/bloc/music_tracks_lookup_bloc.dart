import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';

import 'package:flutter_advanced_ui/shared/data/music_data_repository.dart';
import 'package:flutter_advanced_ui/shared/model/track.dart';

import 'music_data_states.dart';

class LookupTracks {
  final String albumId;

  const LookupTracks({
    @required this.albumId,
  }) : assert(albumId != null);
}

class TracksLoaded extends MusicDataState {
  final List<Track> tracks;

  const TracksLoaded({
    @required this.tracks,
  }) : assert(tracks != null);
}

class MusicTracksLookupBloc extends Bloc<LookupTracks, MusicDataState> {
  final MusicDataRepository repository;

  MusicTracksLookupBloc({
    @required this.repository,
  }) : assert(repository != null);

  @override
  MusicDataState get initialState => DataEmpty();

  @override
  Stream<MusicDataState> mapEventToState(LookupTracks event) async* {
    yield DataLoading();
    try {
      if (event is LookupTracks) {
        final tracks = await repository.getTracks(event.albumId);
        yield TracksLoaded(tracks: tracks);
      }
    } catch (_error) {
      yield DataError();
    }
  }
}

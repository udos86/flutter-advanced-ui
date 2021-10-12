import 'package:bloc/bloc.dart';

import 'package:flutter_advanced_ui/shared/data/music_data_repository.dart';
import 'package:flutter_advanced_ui/shared/model/track.dart';

import 'music_data_states.dart';

class LookupTracks {
  final String albumId;

  const LookupTracks({
    required this.albumId,
  });
}

class TracksLoaded extends MusicDataState {
  final List<Track> tracks;

  const TracksLoaded({
    required this.tracks,
  });
}

class MusicTracksLookupBloc extends Bloc<LookupTracks, MusicDataState> {
  final MusicDataRepository repository;

  MusicTracksLookupBloc({
    required this.repository,
  }) : super(DataEmpty());

  @override
  Stream<MusicDataState> mapEventToState(LookupTracks event) async* {
    yield DataLoading();
    try {
      if (event is LookupTracks) {
        final tracks = await repository.getTracksByAlbum(event.albumId);
        yield TracksLoaded(tracks: tracks);
      }
    } catch (_error) {
      yield const DataError('Error');
    }
  }
}

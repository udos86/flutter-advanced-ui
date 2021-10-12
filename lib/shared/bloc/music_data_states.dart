abstract class MusicDataState {
  const MusicDataState();
}

class DataEmpty extends MusicDataState {}

class DataError extends MusicDataState {
  final String message;

  const DataError(this.message);
}

class DataLoading extends MusicDataState {}

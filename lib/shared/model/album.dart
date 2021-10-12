class Album {
  final String artist;
  final String artworkUrl;
  final String id;
  final DateTime release;
  final String title;

  Album({
    required this.artist,
    required this.artworkUrl,
    required this.id,
    required this.release,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      artist: json['artistName'],
      artworkUrl: (json['artworkUrl100'] as String)
          .replaceFirst('100x100bb', '400x400bb'),
      id: json['collectionId'].toString(),
      release: DateTime.parse(json['releaseDate']),
      title: json['collectionName'],
    );
  }
}

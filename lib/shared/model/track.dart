class Track {
  final String id;
  final Duration length;
  final int number;
  final String previewUrl;
  final DateTime release;
  final String title;

  Track({
    required this.id,
    required this.length,
    required this.number,
    required this.previewUrl,
    required this.release,
    required this.title,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['trackId'].toString(),
      length: Duration(milliseconds: json['trackTimeMillis']),
      number: json['trackNumber'],
      previewUrl: json['previewUrl'],
      release: DateTime.parse(json['releaseDate']),
      title: json['trackName'],
    );
  }
}

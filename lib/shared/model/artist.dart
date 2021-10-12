class Artist {
  final String name;
  final String id;

  Artist({
    required this.name,
    required this.id,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      name: json['artistName'],
      id: json['artistId'].toString(),
    );
  }
}

class Artist {
  final String name;
  final String id;

  Artist({
    this.name,
    this.id,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      name: json['artistName'],
      id: json['artistId'].toString(),
    );
  }
}

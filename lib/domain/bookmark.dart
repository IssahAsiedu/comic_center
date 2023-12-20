class Bookmark {
  final String pk;
  final String thumbnail;
  final String type;
  final String name;

  Bookmark({
    required this.pk,
    required this.thumbnail,
    required this.type,
    required this.name,
  });

  factory Bookmark.fromMap(Map<String, dynamic> json) {
    String pk = json['pk'];
    String thumbnail = json['thumbnail'];
    String type = json['type'];
    String name = json['name'];

    return Bookmark(
      pk: pk,
      thumbnail: thumbnail,
      type: type,
      name: name,
    );
  }
}

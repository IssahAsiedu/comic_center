class Bookmark {
  final String pk;
  final String thumbnail;
  final String type;
  final String name;
  final String id;

  Bookmark({
    required this.pk,
    required this.thumbnail,
    required this.type,
    required this.name,
    required this.id,
  });

  factory Bookmark.fromMap(Map<String, dynamic> json) {
    String pk = json['pk'];
    String thumbnail = json['thumbnail'];
    String type = json['type'];
    String name = json['name'];
    String id = json['id'];

    return Bookmark(
      pk: pk,
      thumbnail: thumbnail,
      type: type,
      name: name,
      id: id,
    );
  }
}

class Character {
  final int id;
  final String name;
  final String? thumbnail;

  Character({required this.id, required this.name, required this.thumbnail});

  factory Character.fromMap(Map<String, dynamic> json) {
    var base = json["thumbnail"]["path"];
    var extension = json["thumbnail"]["extension"];
    return Character(id: json["id"], name: json["name"], thumbnail: '${base}/detail.${extension}');
  }
}

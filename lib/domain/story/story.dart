import 'package:comics_center/domain/item.dart';

class Story extends Item {
  final String? thumbnail;
  final String? description;
  final String? type;

  Story(
      {required super.id,
      required super.name,
      required this.thumbnail,
      this.description,
      this.type});

  factory Story.fromMap(Map<String, dynamic> json) {
    String? thumbnail;

    if (json["thumbnail"] != null) {
      thumbnail =
          '${json["thumbnail"]["path"]}/detail.${json["thumbnail"]["extension"]}';
    }

    return Story(
        id: json["id"],
        name: json["title"],
        thumbnail: thumbnail,
        type: json["type"],
        description: json['description']);
  }
}

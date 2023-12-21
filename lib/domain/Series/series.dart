import 'package:comics_center/domain/item.dart';

class Series extends Item {
  final String? thumbnail;
  final String? description;

  Series({
    required super.id,
    required super.name,
    required this.thumbnail,
    this.description,
  });

  factory Series.fromMap(Map<String, dynamic> json) {
    String? thumbnail;

    if (json["thumbnail"] != null) {
      thumbnail =
          '${json["thumbnail"]["path"]}/detail.${json["thumbnail"]["extension"]}';
    }

    return Series(
      id: json["id"],
      name: json["title"],
      thumbnail: thumbnail,
      description: json['description'],
    );
  }
}

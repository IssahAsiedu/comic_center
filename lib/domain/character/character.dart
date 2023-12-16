import 'package:comics_center/domain/item.dart';

class Character extends Item {
  final String? thumbnail;

  Character({
    required super.id,
    required super.name,
    required this.thumbnail,
  });

  factory Character.fromMap(Map<String, dynamic> map) {
    var base = map["thumbnail"]["path"];
    var extension = map["thumbnail"]["extension"];
    return Character(
      id: map["id"],
      name: map["name"],
      thumbnail: '$base/detail.$extension',
    );
  }
}

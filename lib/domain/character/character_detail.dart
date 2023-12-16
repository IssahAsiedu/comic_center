import 'package:comics_center/domain/item.dart';
import 'character.dart';

class CharacterDetails extends Character {
  final List<Item> comics;
  final List<Item> series;
  final String description;

  CharacterDetails({
    required super.id,
    required super.name,
    required super.thumbnail,
    required this.description,
    this.comics = const <Item>[],
    this.series = const <Item>[],
  });

  factory CharacterDetails.fromMap(Map<String, dynamic> map) {
    var base = map["thumbnail"]["path"];
    var extension = map["thumbnail"]["extension"];

    var comics = (map["comics"]["items"] as List<dynamic>)
        .map((i) => Item.fromMap(i))
        .toList();
    var series = (map["series"]["items"] as List<dynamic>)
        .map((i) => Item.fromMap(i))
        .toList();

    return CharacterDetails(
      id: map["id"],
      name: map["name"],
      thumbnail: '$base/detail.$extension',
      comics: comics,
      description: map["description"],
      series: series,
    );
  }
}

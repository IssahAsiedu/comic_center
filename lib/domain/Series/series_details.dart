import 'package:comics_center/domain/Series/series.dart';
import 'package:comics_center/domain/item.dart';

class SeriesDetails extends Series {
  SeriesDetails({
    required super.id,
    required super.name,
    required super.thumbnail,
    required this.comics,
    super.description,
  });

  final List<Item> comics;

  factory SeriesDetails.fromMap(Map<String, dynamic> map) {
    String? thumbnail;

    if (map["thumbnail"] != null) {
      thumbnail =
          '${map["thumbnail"]["path"]}/detail.${map["thumbnail"]["extension"]}';
    }

    var comics = (map["comics"]["items"] as List<dynamic>)
        .map((i) => Item.fromMap(i))
        .toList();

    return SeriesDetails(
      id: map["id"],
      name: map["title"],
      thumbnail: thumbnail,
      description: map['description'],
      comics: comics,
    );
  }
}

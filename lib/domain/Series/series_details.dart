import 'package:comics_center/domain/Series/series.dart';
import 'package:comics_center/domain/comic/comic.dart';

class SeriesDetails extends Series {
  SeriesDetails({
    required super.id,
    required super.name,
    required super.thumbnail,
    required this.comics,
    super.description,
  });

  final List<Comic> comics;

  factory SeriesDetails.fromMap(Map<String, dynamic> json) {
    String? thumbnail;

    if (json["thumbnail"] != null) {
      thumbnail =
          '${json["thumbnail"]["path"]}/detail.${json["thumbnail"]["extension"]}';
    }

    return SeriesDetails(
      id: json["id"],
      name: json["title"],
      thumbnail: thumbnail,
      description: json['description'],
      comics: [],
    );
  }
}

import 'package:comics_center/domain/item.dart';

class Comic extends Item {
  final int issueNumber;
  final String format;
  final String thumbnail;

  Comic({
    required super.id,
    required super.name,
    required this.issueNumber,
    required this.format,
    required this.thumbnail,
  });

  factory Comic.fromMap(Map<String, dynamic> json) {
    var thumbnail =
        '${json["thumbnail"]["path"]}/detail.${json["thumbnail"]["extension"]}';

    return Comic(
        id: json["id"],
        name: json["title"],
        issueNumber: json["issueNumber"],
        thumbnail: thumbnail,
        format: json["format"]);
  }
}

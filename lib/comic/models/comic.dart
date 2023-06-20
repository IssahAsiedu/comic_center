import '../../shared/models/item.dart';

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
    return Comic(
        id: json["id"],
        name: json["title"],
        issueNumber: json["issueNumber"],
        thumbnail: '${json["thumbnail"]["path"]}/detail.${json["thumbnail"]["extension"]}',
        format: json["format"]
    );
  }
}

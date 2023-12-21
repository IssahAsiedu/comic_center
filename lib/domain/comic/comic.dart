import 'package:comics_center/domain/book_markable.dart';
import 'package:comics_center/domain/item.dart';
import 'package:uuid/uuid.dart';

class Comic extends Item implements Bookmarkable {
  final int issueNumber;
  final String format;
  final String thumbnail;

  Comic({
    required super.id,
    required super.name,
    required this.issueNumber,
    required this.format,
    required this.thumbnail,
    this.bookMarked = false,
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

  @override
  bool bookMarked;

  @override
  get bookmarkData => {
        "pk": const Uuid().v4(),
        "name": name,
        "thumbnail": thumbnail,
        "id": id,
        "type": "Comic"
      };
}

import 'package:comics_center/domain/book_markable.dart';
import 'package:comics_center/domain/item.dart';
import 'package:uuid/uuid.dart';

class Series extends Item implements Bookmarkable {
  final String? thumbnail;
  final String? description;

  Series({
    required super.id,
    required super.name,
    required this.thumbnail,
    this.description,
    this.bookMarked = false,
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

  @override
  bool bookMarked;

  @override
  get bookmarkData => {
        "pk": const Uuid().v4(),
        "name": name,
        "thumbnail": thumbnail,
        "id": id,
        "type": "Series"
      };
}

import 'comic_price.dart';
import 'comic.dart';

class ComicDetails extends Comic {
  final String? description;
  final int pageCount;
  final List<String> images;
  final List<ComicPrice> prices;

  ComicDetails({
    required super.id,
    required super.name,
    required super.issueNumber,
    required super.format,
    required super.thumbnail,
    this.description = "",
    this.pageCount = 0,
    this.prices = const <ComicPrice>[],
    this.images = const <String>[],
  });

  factory ComicDetails.fromMap(Map<String, dynamic> map) {
    var images = (map["images"] as List<dynamic>)
        .map((img) => "${img["path"]}/detail.${img["extension"]}")
        .toList();

    var prices = (map["prices"] as List<dynamic>)
        .map((price) => ComicPrice.fromMap(price))
        .toList();

    var thumbnail =
        '${map["thumbnail"]["path"]}/detail.${map["thumbnail"]["extension"]}';

    return ComicDetails(
        id: map["id"],
        name: map["title"],
        issueNumber: map["issueNumber"],
        thumbnail: thumbnail,
        format: map["format"],
        images: images,
        prices: prices,
        pageCount: map["pageCount"],
        description: map["description"]);
  }
}

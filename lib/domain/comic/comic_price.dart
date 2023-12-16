class ComicPrice {
  final String type;
  final String price;

  ComicPrice({required this.type, required this.price});

  factory ComicPrice.fromMap(Map<String, dynamic> map) {
    return ComicPrice(type: map["type"], price: "${map["price"]}");
  }

  String get displayString {
    var s = type.replaceAllMapped(
      RegExp(r"([A-Z]+)"),
      (match) => " ${match.group(0)}",
    );
    return s.toUpperCase();
  }
}

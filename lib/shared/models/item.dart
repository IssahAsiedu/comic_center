class Item {
  final int id;
  final String name;

  Item({required this.id, required this.name});

  factory Item.fromMap(Map<String, dynamic> map) {
    var stringArray = (map["resourceURI"] as String).split("/");
    var itemId = stringArray[stringArray.length - 1];
    return Item(id: int.parse(itemId), name: map["name"]);
  }
}

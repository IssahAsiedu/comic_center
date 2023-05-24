class Comic {
  final int id;
  final String title;
  final int issueNumber;
  final String format;
  final String thumbnail;

  Comic({
    required this.id,
    required this.title,
    required this.issueNumber,
    required this.format,
    required this.thumbnail,
  });

  factory Comic.fromMap(Map<String, dynamic> json) {
    return Comic(
        id: json["id"],
        title: json["title"],
        issueNumber: json["issueNumber"],
        thumbnail: '${json["thumbnail"]["path"]}/detail.${json["thumbnail"]["extension"]}',
        format: json["format"]
    );
  }
}

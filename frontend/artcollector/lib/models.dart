class Artwork {
  late String id;
  late String info;
  late String description;
  late String name;
  // String author;
  // String folder;
  // String dateOfCreation;
  // String medium;
  // String dimensions;
  // String style;
  // String exhibition;
  // String memo;
  // String picture;
  // DateTime created;
  // DateTime updated;

  Artwork({
    required this.id,
    required this.info,
    required this.description,
    required this.name,
    // required this.author,
    // required this.folder,
    // required this.dateOfCreation,
    // required this.medium,
    // required this.dimensions,
    // required this.style,
    // required this.exhibition,
    // required this.memo,
    // required this.picture,
    // required this.created,
    // required this.updated,
  });

  // Factory method to create an instance of Artwork from JSON
  factory Artwork.fromJson(Map<String, dynamic> json) {
    return Artwork(
      id: json['id'] as String,
      info: json['info'] as String,
      description: json['description'] as String,
      name: json['name'] as String,
      // author: json['author'],
      // folder: json['folder'],
      // dateOfCreation: json['date_of_creation'],
      // medium: json['medium'],
      // dimensions: json['dimensions'],
      // style: json['style'],
      // exhibition: json['exhibition'],
      // memo: json['memo'],
      // picture: json['picture'],
      // created: DateTime.parse(json['created']),
      // updated: DateTime.parse(json['updated']),
    );
  }
}
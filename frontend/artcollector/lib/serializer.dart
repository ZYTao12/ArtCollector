class ArtworkSerializer {
  final String? id;
  final String? label_path;
  final String? folder;
  final String? name;
  final String? date_of_creation;
  final String? medium;
  final String? description;
  final String? author;

  ArtworkSerializer({
    this.id,
    this.label_path,
    this.folder,
    this.name,
    this.date_of_creation,
    this.medium,
    this.description,
    this.author
  });

  // Factory constructor for creating a new ArtworkSerializer instance from a map structure
  factory ArtworkSerializer.fromJson(Map<String, dynamic> json) {
    return ArtworkSerializer(
      id: json['id'] as String?,
      label_path: json['label_path'] as String?,
      folder: json['folder'] as String?,
      name: json['name'] as String?,
      date_of_creation: json['date_of_creation'] as String?,
      medium: json['medium'] as String?,
      description: json['description'] as String?,
      author: json['author'] as String?,
    );
  }

  // Method to convert ArtworkSerializer instance into a map
  Map<String, dynamic> toJson() => {
    'id': id,
    'label_path': label_path,
    'folder': folder,
    'name': name,
    'date_of_creation': date_of_creation,
    'medium': medium,
    'description': description,
    'author': author
  };
}
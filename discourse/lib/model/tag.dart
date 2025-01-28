/// Model class to represent a Tag
class Tag {
  Tag ({required this.tagDescription});
  final String tagDescription;

  Map<String, dynamic> toMap() {
    return {
      'tagDescription': tagDescription,
    };
  }

    factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      tagDescription: map['tagDescription'],
    );
  }
}
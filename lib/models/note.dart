class Note {
  final String id;
  final String title;
  final String content;
  final String category;
  final DateTime updatedAt;
  final bool isPinned;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.updatedAt,
    this.isPinned = false,
  });

  // ponytail: immutable in-memory model. Upgrade path: add fromJson/toJson when API or SQLite integrated.
}

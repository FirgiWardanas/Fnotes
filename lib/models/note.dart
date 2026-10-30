enum NotePriority {
  rendah('Rendah'),
  sedang('Sedang'),
  tinggi('Tinggi'),
  mendesak('Mendesak');

  final String label;
  const NotePriority(this.label);
}

class Note {
  final String id;
  final String title;
  final String content;
  final String category;
  final NotePriority priority;
  final DateTime date;
  final bool isPinned;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.priority,
    required this.date,
    this.isPinned = false,
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    NotePriority? priority,
    DateTime? date,
    bool? isPinned,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      date: date ?? this.date,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  // ponytail: immutable in-memory entity. Upgrade path: add json serialization when backend arrives.
}

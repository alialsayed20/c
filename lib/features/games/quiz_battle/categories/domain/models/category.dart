class Category {
  const Category({
    required this.id,
    required this.title,
    this.icon,
  });

  final String id;
  final String title;
  final String? icon;

  Category copyWith({
    String? id,
    String? title,
    String? icon,
    bool clearIcon = false,
  }) {
    return Category(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: clearIcon ? null : (icon ?? this.icon),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Category &&
        other.id == id &&
        other.title == title &&
        other.icon == icon;
  }

  @override
  int get hashCode => Object.hash(id, title, icon);
}
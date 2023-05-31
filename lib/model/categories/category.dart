class Category {
  Category({
    required this.id,
    required this.name,
    this.icon,
  });

  String id;
  String name;
  String? icon;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
    );
  }
}

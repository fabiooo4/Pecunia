class Category {
  Category(
      {required this.id,
      required this.name,
      required this.icon,
      this.categoryIcon});

  String id;
  String name;
  String icon;
  String? categoryIcon;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
    );
  }
}

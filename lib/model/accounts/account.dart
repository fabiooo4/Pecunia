class Account {
  Account({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      name: json['name'],
    );
  }
}

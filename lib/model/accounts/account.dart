class Account {
  Account({
    required this.id,
    required this.name,
    required this.totalBalance,
  });

  String id;
  String name;
  double totalBalance;

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      name: json['name'],
      totalBalance: json['total_balance'].toDouble(),
    );
  }
}

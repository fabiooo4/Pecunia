import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'expense.dart';

final List<Expense> _expenseList = [
];

final categoryProvider = Provider((ref) => _expenseList);

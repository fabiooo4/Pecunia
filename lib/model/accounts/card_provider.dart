import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pecunia/model/accounts/card.dart';

final List<CardAccount> _accountList = [
  CardAccount(name: 'Cash', totalBalance: 1000, income: 20, expense: 10),
  CardAccount(name: 'Bank', totalBalance: 150000, income: 3000, expense: 500),
  CardAccount(name: 'Credit Card', totalBalance: 1000, income: 10, expense: 40),
];

final accountProvider = Provider((ref) => _accountList);

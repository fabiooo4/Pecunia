import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccountCard extends StatefulWidget {
  const AccountCard(
      {Key? key,
      required this.name,
      required this.onTap,
      required this.totalBalance,
      required this.income,
      required this.expense,
      required this.active})
      : super(key: key);

  final String name;
  final VoidCallback onTap;
  final double totalBalance;
  final double income;
  final double expense;
  final bool active;

  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  @override
  Widget build(BuildContext context) {
    final cardColor = widget.active ? Colors.green : Colors.blue;
    return InkWell(
      enableFeedback: true,
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      onTap: () {
        widget.onTap();

        HapticFeedback.mediumImpact();
      },
      child: Stack(
        children: [
          Container(
            width: 300,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: cardColor,
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              widget.name,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Text(
              '€ ${widget.totalBalance.toStringAsFixed(2)}',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Text(
              '€ ${widget.income.toStringAsFixed(2)}',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Text(
              '€ ${widget.expense.toStringAsFixed(2)}',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

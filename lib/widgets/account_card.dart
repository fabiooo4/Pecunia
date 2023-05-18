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
    final shadow = widget.active
        ? const BoxShadow(
            color: Colors.green,
            blurRadius: 5,
            offset: Offset(0, 8),
          )
        : const BoxShadow(
            color: Colors.blueAccent,
            blurRadius: 0,
            offset: Offset(0, 0),
          );
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
              /* boxShadow: [
                shadow,
              ], */
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              widget.name,
              style: const TextStyle(
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
              style: const TextStyle(
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
              style: const TextStyle(
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
              style: const TextStyle(
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

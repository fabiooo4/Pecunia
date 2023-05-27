import 'package:flutter/material.dart';

class Filter extends StatefulWidget {
  const Filter(
      {Key? key, required this.name, required this.active, required this.onTap})
      : super(key: key);

  final String name;
  final bool active;
  final VoidCallback onTap;

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  @override
  Widget build(BuildContext context) {
    final cardColor =
        widget.active ? Colors.lightGreen : const Color(0xFF072E08);

    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Chip(
            label: Text(widget.name),
            labelStyle: const TextStyle(color: Colors.white),
            backgroundColor: cardColor,
            padding: const EdgeInsets.all(5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            side: const BorderSide(
              color: Colors.transparent,
              width: 0,
            )),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MenuTileWidget extends StatelessWidget {
  const MenuTileWidget(
      {super.key,
      required this.leadingIcon,
      required this.title,
      this.onTap,
      this.endIcon = true});

  final IconData leadingIcon;
  final Text title;
  final void Function()? onTap;
  final bool endIcon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.lightGreen.withOpacity(0.2),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(
          leadingIcon,
          color: Colors.lightGreen,
        ),
      ),
      title: title,
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: Colors.grey,
              ),
            )
          : null,
      onTap: onTap,
    );
  }
}

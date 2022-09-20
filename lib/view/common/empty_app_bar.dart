import 'package:flutter/material.dart';

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EmptyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Colors.blue,
    );
  }

  @override
  Size get preferredSize =>  Size.zero;
}

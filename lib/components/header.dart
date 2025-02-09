import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSize {
  const Header({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(150.0);

  @override
  Widget get child => throw UnimplementedError();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 100,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Center(
        child: Text(
          "GeoShield",
          style: TextStyle(
            shadows: const [BoxShadow(color: Colors.black, blurRadius: 40)],
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

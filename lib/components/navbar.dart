import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  Navbar({
    super.key,
  });

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: const [
        NavigationDestination(icon: Icon(Icons.waves), label: 'Inondation'),
        NavigationDestination(icon: Icon(Icons.landslide), label: 'Glissement'),
        NavigationDestination(icon: Icon(Icons.forest), label: 'Réserves'),
      ],
      onDestinationSelected: (int index) {
        setState(() {
          selectedIndex = index;
        });
      },
      selectedIndex: selectedIndex,
    );
  }
}

import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const Navbar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.waves), label: 'Inondation'),
        NavigationDestination(icon: Icon(Icons.landslide), label: 'Glissement'),
        NavigationDestination(icon: Icon(Icons.forest), label: 'Réserves'),
      ],
    );
  }
}
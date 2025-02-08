import 'package:flutter/material.dart';
import 'package:geoshield/components/map_screen.dart';
import 'package:geoshield/components/navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _navIndex = 0;
  final Set<String> _selectedLayers = {};

  void _toggleLayer(String layer) {
    setState(() {
      _selectedLayers.contains(layer)
          ? _selectedLayers.remove(layer)
          : _selectedLayers.add(layer);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(
          child: Text(
            widget.title,
            style: TextStyle(
              shadows: const [BoxShadow(color: Colors.black, blurRadius: 40)],
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: MapScreen(
        selectedLayers: _selectedLayers,
        onLayerToggled: _toggleLayer,
      ),
      bottomNavigationBar: Navbar(
        selectedIndex: _navIndex,
        onDestinationSelected: (index) => setState(() => _navIndex = index),
      ),
    );
  }
}

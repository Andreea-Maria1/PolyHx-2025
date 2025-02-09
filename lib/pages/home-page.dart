import 'package:flutter/material.dart';
import 'package:geoshield/components/header.dart';
import 'package:geoshield/components/map_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      appBar: const Header(),
      body: MapScreen(
        selectedLayers: _selectedLayers,
        onLayerToggled: _toggleLayer,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:geoshield/components/map_screen.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MapScreen(
      selectedLayers: {},
      onLayerToggled: (String) {},
    );
  }
}

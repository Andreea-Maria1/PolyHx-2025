import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Constructibilité des terrains")),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: const LatLng(45.4215, -75.6993), // Coordonnées d'Ottawa
          initialZoom: 5.5,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png", // Corrigé pour éviter l'erreur de sous-domaines
          ),
        ],
      ),
    );
  }
}

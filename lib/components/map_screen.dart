import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class MapScreen extends StatefulWidget {
  final Set<String> selectedLayers;
  final Function(String) onLayerToggled;

  const MapScreen({
    super.key,
    required this.selectedLayers,
    required this.onLayerToggled,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  List<Polygon> floodPolygons = []; // Stockage des polygones inondables
  bool isFloodLayerVisible = false;

  @override
  void initState() {
    super.initState();
    _loadFloodLayer();
  }

  Future<void> _loadFloodLayer() async {
    try {
      // Charger le fichier JSON
      final String data = await rootBundle.loadString('assets/flood2.json');
      final Map<String, dynamic> jsonData = json.decode(data);

      // Extraire les polygones des inondations
      final List<dynamic> features = jsonData['features'] ?? [];
      List<Polygon> tempPolygons = features
          .map((feature) {
            if (feature['geometry']['type'] == 'Polygon') {
              final List<dynamic> coordinates = feature['geometry']['coordinates'][0];

              List<LatLng> points = coordinates.map<LatLng>((coord) {
                return LatLng(coord[1], coord[0]); // Latitude, Longitude
              }).toList();

              return Polygon(
                points: points,
                color: Colors.blue.withOpacity(0.3), // Couleur semi-transparente
                borderColor: Colors.blue,
                borderStrokeWidth: 2,
              );
            }
            return null;
          })
          .whereType<Polygon>()
          .toList();

      setState(() {
        floodPolygons = tempPolygons;
      });

      print("✅ Données d'inondation chargées avec succès !");
    } catch (e) {
      print("❌ Erreur lors du chargement des données d'inondation : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: const MapOptions(
            initialCenter: LatLng(47.5, -70.0), // Centrage au Québec
            initialZoom: 7,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            ),
            if (isFloodLayerVisible)
              PolygonLayer(
                polygons: floodPolygons,
              ),
          ],
        ),
        Positioned(
          top: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildLayerButton(),
            ],
          ),
        ),
        _buildZoomControls(),
      ],
    );
  }

  Widget _buildLayerButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          Icons.layers,
          color: isFloodLayerVisible ? Colors.orange : Colors.grey,
        ),
        onPressed: () {
          setState(() {
            isFloodLayerVisible = !isFloodLayerVisible;
          });
        },
        padding: const EdgeInsets.all(12),
      ),
    );
  }

  Widget _buildZoomControls() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              mini: true,
              heroTag: 'zoomIn',
              onPressed: () => _mapController.move(
                _mapController.camera.center,
                _mapController.camera.zoom + 1,
              ),
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              mini: true,
              heroTag: 'zoomOut',
              onPressed: () => _mapController.move(
                _mapController.camera.center,
                _mapController.camera.zoom - 1,
              ),
              child: const Icon(Icons.remove),
            ),
          ],
        ),
      ),
    );
  }
}

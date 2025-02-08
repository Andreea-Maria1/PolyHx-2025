import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/services.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final GeoJsonParser myGeoJson = GeoJsonParser(); // ✅ Ajout du parser GeoJSON
  bool isFloodLayerVisible = false; // État pour afficher/masquer la couche

  @override
  void initState() {
    super.initState();
    loadGeoJson();
  }

  Future<void> loadGeoJson() async {
    try {
      final String data = await rootBundle.loadString('assets/flood.geojson');
      print("✅ Fichier GeoJSON chargé avec succès !");
      myGeoJson.parseGeoJsonAsString(data);
      print("✅ Données GeoJSON parsées !");
      setState(() {});
    } catch (e) {
      print("❌ Erreur lors du chargement du GeoJSON : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: const LatLng(45.5017, -73.5673),
            initialZoom: 10,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            ),
            if (isFloodLayerVisible) ...[
              PolygonLayer(polygons: myGeoJson.polygons), // ✅ Affichage des polygones du GeoJSON
              PolylineLayer(polylines: myGeoJson.polylines), // Si des lignes sont présentes
              MarkerLayer(markers: myGeoJson.markers), // Si des points sont présents
            ],
          ],
        ),
        // Boutons de zoom
        Align(
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
        ),
        // Bouton pour activer/désactiver la couche GeoJSON
        Positioned(
          top: 10,
          right: 10,
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                isFloodLayerVisible = !isFloodLayerVisible; // ✅ Active/Désactive la couche
              });
            },
            child: Icon(
              isFloodLayerVisible ? Icons.layers : Icons.layers_clear,
            ),
          ),
        ),
      ],
    );
  }
}

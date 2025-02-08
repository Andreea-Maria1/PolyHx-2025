import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
<<<<<<< HEAD
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/services.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
=======
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final Set<String> selectedLayers;
  final Function(String) onLayerToggled;

  const MapScreen({
    super.key,
    required this.selectedLayers,
    required this.onLayerToggled,
  });
>>>>>>> d12723411f34551827c4ded244f9afd4dd7fb60f

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
<<<<<<< HEAD
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
=======
  final _layerOptions = {
    'inondation': (Icons.waves, 'Inondations', Colors.blue),
    'glissement': (Icons.landslide, 'Glissements', Colors.orange),
    'reserve': (Icons.forest, 'Réserves', Colors.green),
  };
  bool _showLayerMenu = false;
>>>>>>> d12723411f34551827c4ded244f9afd4dd7fb60f

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
<<<<<<< HEAD
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
=======
            ..._buildActiveLayers(),
            _buildZoomControls(),
          ],
        ),
        Positioned(
          top: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildLayerButton(),
              if (_showLayerMenu) _buildLayerMenu(),
            ],
>>>>>>> d12723411f34551827c4ded244f9afd4dd7fb60f
          ),
        ),
      ],
    );
  }
<<<<<<< HEAD
=======

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
          color: widget.selectedLayers.isNotEmpty ? Colors.orange : Colors.grey,
        ),
        onPressed: () => setState(() => _showLayerMenu = !_showLayerMenu),
        padding: const EdgeInsets.all(12),
      ),
    );
  }

  Widget _buildLayerMenu() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      constraints: const BoxConstraints(maxWidth: 160),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _layerOptions.entries.map((entry) {
          final isActive = widget.selectedLayers.contains(entry.key);
          return InkWell(
            onTap: () => widget.onLayerToggled(entry.key),
            child: Container(
              width: 160,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: isActive ? entry.value.$3.withOpacity(0.1) : null,
                borderRadius: BorderRadius.circular(4),
                border: isActive
                    ? Border.all(color: entry.value.$3, width: 1)
                    : Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
              ),
              child: Row(
                children: [
                  Icon(entry.value.$1, color: entry.value.$3),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value.$2,
                      style: TextStyle(
                        color: isActive ? Colors.black : Colors.grey,
                        fontWeight:
                            isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<TileLayer> _buildActiveLayers() {
    return _layerOptions.entries
        .where((entry) => widget.selectedLayers.contains(entry.key))
        .map((entry) => TileLayer(
              urlTemplate: 'https://server.com/${entry.key}/{z}/{x}/{y}.png',
              tileProvider: NonEvictingNetworkTileProvider(),
            ))
        .toList();
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

class NonEvictingNetworkTileProvider extends NetworkTileProvider {
  NonEvictingNetworkTileProvider({super.headers});

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    return NetworkImage(
      'https://server.com/${coordinates.z}/${coordinates.x}/${coordinates.y}.png',
      headers: headers,
    );
  }
>>>>>>> d12723411f34551827c4ded244f9afd4dd7fb60f
}

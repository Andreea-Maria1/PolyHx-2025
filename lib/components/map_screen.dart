import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:proj4dart/proj4dart.dart' as proj;

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
  final TextEditingController _searchController = TextEditingController();
  bool isFloodLayerVisible = false;
  bool isLandslideLayerVisible = false;
  bool isReserveLayerVisible = false;

  final projWGS84 =
      proj.Projection.add('EPSG:4326', '+proj=longlat +datum=WGS84 +no_defs');
  final projMercator = proj.Projection.add('EPSG:3857',
      '+proj=merc +lon_0=0 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs');

  Map<String, (IconData, String, Color, void Function())> get layerOptions {
    return {
      'inondation': (
        Icons.waves,
        'Inondations',
        Colors.blue,
        () {
          isFloodLayerVisible = !isFloodLayerVisible;
        }
      ),
      'glissement': (
        Icons.landslide,
        'Glissements',
        Colors.orange,
        () {
          isLandslideLayerVisible = !isLandslideLayerVisible;
        }
      ),
      'reserve': (
        Icons.forest,
        'Réserves',
        Colors.green,
        () {
          isReserveLayerVisible = !isReserveLayerVisible;
        }
      ),
    };
  }

  bool _showLayerMenu = false;
  List<Polygon> floodPolygons = []; // Stockage des polygones inondables
  List<Polygon> landslidePolygons = [];
  List<Polygon> reservePolygons = [];

  @override
  void initState() {
    super.initState();
    _loadFloodLayer();
    _loadReserveLayer();
    _loadLandslideLayer();
  }

  Future<void> _loadFloodLayer() async {
    try {
      // Charger le fichier JSON
      final String data = await rootBundle.loadString('assets/flood.json');
      final Map<String, dynamic> jsonData = json.decode(data);

      // Extraire les polygones des inondations
      final List<dynamic> features = jsonData['features'] ?? [];
      List<Polygon> tempPolygons = features
          .map((feature) {
            if (feature['geometry']['type'] == 'Polygon') {
              final List<dynamic> coordinates =
                  feature['geometry']['coordinates'][0];

              List<LatLng> points = coordinates.map<LatLng>((coord) {
                return LatLng(coord[1], coord[0]); // Latitude, Longitude
              }).toList();

              return Polygon(
                points: points,
                color:
                    Colors.blue.withOpacity(0.3), // Couleur semi-transparente
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

  Future<void> _loadLandslideLayer() async {
    try {
      // Charger le fichier JSON
      final String data = await rootBundle.loadString('assets/glissement.json');
      final Map<String, dynamic> jsonData = json.decode(data);

      // Extraire les polygones des inondations
      final List<dynamic> features = jsonData['features'] ?? [];
      List<Polygon> tempPolygons = features
          .map((feature) {
            if (feature['geometry']['type'] == 'Polygon') {
              final List<dynamic> coordinates =
                  feature['geometry']['coordinates'][0];

              List<LatLng> points = coordinates.map<LatLng>((coord) {
                double x = coord[0].toDouble(); // X (Mercator)
                double y = coord[1].toDouble(); // Y (Mercator)

                // Convert from Web Mercator to Lat/Lng
                var result =
                    projMercator.transform(projWGS84, proj.Point(x: x, y: y));
                double lon = result.x;
                double lat = result.y;

                return LatLng(lat, lon);
              }).toList();
              return Polygon(
                points: points,
                color:
                    Colors.orange.withOpacity(0.3), // Couleur semi-transparente
                borderColor: Colors.orange,
                borderStrokeWidth: 2,
              );
            }
            return null;
          })
          .whereType<Polygon>()
          .toList();

      setState(() {
        landslidePolygons = tempPolygons;
      });

      print("✅ Données de glissement chargées avec succès !");
    } catch (e) {
      print("❌ Erreur lors du chargement des données de glissement : $e");
    }
  }

  Future<void> _loadReserveLayer() async {
    try {
      // Charger le fichier JSON
      final String data =
          await rootBundle.loadString('assets/ecoterritoires.json');
      final Map<String, dynamic> jsonData = json.decode(data);

      // Extraire les polygones des inondations
      final List<dynamic> features = jsonData['features'] ?? [];
      List<Polygon> tempPolygons = features
          .map((feature) {
            if (feature['geometry']['type'] == 'Polygon') {
              final List<dynamic> coordinates =
                  feature['geometry']['coordinates'][0];

              List<LatLng> points = coordinates.map<LatLng>((coord) {
                return LatLng(coord[1], coord[0]); // Latitude, Longitude
              }).toList();

              return Polygon(
                points: points,
                color:
                    Colors.blue.withOpacity(0.3), // Couleur semi-transparente
                borderColor: Colors.green,
                borderStrokeWidth: 2,
              );
            }
            return null;
          })
          .whereType<Polygon>()
          .toList();

      setState(() {
        reservePolygons = tempPolygons;
      });

      print("✅ Données de réserve chargées avec succès !");
    } catch (e) {
      print("❌ Erreur lors du chargement des données de réserve : $e");
    }
  }

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    try {
      final response = await http.get(
        Uri.parse(
            'https://nominatim.openstreetmap.org/search?q=$query&format=json&polygon=1&addressdetails=1'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = json.decode(response.body);
        if (results.isNotEmpty) {
          final result = results[0];
          final lat = double.parse(result['lat']);
          final lon = double.parse(result['lon']);

          // Calculate zoom level based on the type and importance of the result
          double zoom = _calculateZoomLevel(result);

          // Animate to the new position with the calculated zoom
          _mapController.move(LatLng(lat, lon), zoom);
        }
      }
    } catch (e) {
      debugPrint('Search error: $e');
    }
  }

  double _calculateZoomLevel(Map<String, dynamic> result) {
    // Get the type of location and bounding box if available
    final type = result['type'];
    final bbox = result['boundingbox'];

    const double maxAllowedZoom = 18.0;

    // Default zoom levels for different location types
    const Map<String, double> typeZoomLevels = {
      'house': 14.0, // Vue autour de la maison
      'building': 14.0, // Vue autour du bâtiment
      'street': 14.0, // Vue des rues environnantes
      'suburb': 13.0, // Vue du quartier
      'village': 12.0, // Vue du village
      'town': 11.0, // Vue de la ville
      'city': 10.0, // Vue plus large de la ville
      'county': 9.0, // Vue du comté
      'state': 7.0, // Vue de la province/état
      'country': 5.0, // Vue du pays
    };

    // If we have a bounding box, calculate zoom based on area size
    if (bbox != null) {
      try {
        final south = double.parse(bbox[0]);
        final north = double.parse(bbox[1]);
        final west = double.parse(bbox[2]);
        final east = double.parse(bbox[3]);

        // Calculate the area size
        final latDiff = (north - south).abs();
        final lonDiff = (east - west).abs();
        final maxDiff = max(latDiff, lonDiff);

        // Formule approximative pour convertir la taille en niveau de zoom
        double computedZoom = 12 - log(maxDiff) / log(2);
        // On borne le zoom pour éviter un agrandissement excessif
        return computedZoom.clamp(5.0, maxAllowedZoom);
      } catch (e) {
        debugPrint('Error calculating zoom from bbox: $e');
      }
    }

    // If no bounding box or calculation failed, use type-based zoom levels
    return typeZoomLevels[type] ??
        typeZoomLevels[result['class']] ??
        11.0; // Default zoom level if type is unknown
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: const MapOptions(
            initialCenter: LatLng(45.5017, -73.5673),
            initialZoom: 10,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            ),
            _buildZoomControls(),
            if (isFloodLayerVisible)
              PolygonLayer(
                polygons: floodPolygons,
              ),
            if (isLandslideLayerVisible)
              PolygonLayer(
                polygons: landslidePolygons,
              ),
            if (isReserveLayerVisible)
              PolygonLayer(
                polygons: reservePolygons,
              ),
          ],
        ),
        // Barre de recherche
        Positioned(
          top: 20,
          left: 20,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
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
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un lieu...',
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _performSearch,
                ),
              ),
              onSubmitted: (_) => _performSearch(),
            ),
          ),
        ),
        // Menu des couches - Corrected section
        Positioned(
          top: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildLayerButton(), // Add the layer button here
              if (_showLayerMenu) _buildLayerMenu(),
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
        children: layerOptions.entries.map((entry) {
          final isActive = widget.selectedLayers.contains(entry.key);
          return InkWell(
            onTap: () {
              widget.onLayerToggled(entry.key);
              entry.value.$4();
            },
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
    if (options.wmsOptions != null) {
      final wms = options.wmsOptions!;
      final bbox = _getBbox(coordinates, options);

      final params = {
        'service': 'WMS',
        'request': 'GetMap',
        'version': wms.version,
        'layers': wms.layers.join(','),
        'styles': options.additionalOptions['styles'] ?? '',
        'format': wms.format,
        'transparent': wms.transparent.toString(),
        'width': '256',
        'height': '256',
        'crs': 'EPSG:3857',
        'bbox': bbox,
      };

      final url = Uri.parse(wms.baseUrl).replace(queryParameters: params);
      return NetworkImage(url.toString(), headers: headers);
    }

    return super.getImage(coordinates, options);
  }

  String _getBbox(TileCoordinates coords, TileLayer options) {
    final crs = options.wmsOptions?.crs ?? const Epsg3857();
    final tileSize = options.tileSize ?? 256.0;
    final nwPoint = Point(coords.x * tileSize, coords.y * tileSize);
    final sePoint = nwPoint + Point(tileSize.toDouble(), tileSize.toDouble());

    final nw = _getCoordinate(nwPoint, coords.z, crs);
    final se = _getCoordinate(sePoint, coords.z, crs);

    return '${nw.longitude},${se.latitude},${se.longitude},${nw.latitude}';
  }

  LatLng _getCoordinate(Point point, int zoom, Crs crs) {
    final scale = 1 << zoom;
    final x = point.x / scale;
    final y = point.y / scale;

    if (crs.code == 'EPSG:3857') {
      return LatLng(
        _yToLat(y),
        _xToLon(x),
      );
    }

    return const LatLng(0, 0);
  }

  double _xToLon(double x) => (x * 360 - 180).toDouble();

  double _yToLat(double y) {
    final n = pi - 2 * pi * y;
    return (180 / pi * atan(0.5 * (exp(n) - exp(-n)))).toDouble();
  }
}

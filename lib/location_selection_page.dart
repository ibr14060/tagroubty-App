import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class LocationSelectionPage extends StatefulWidget {
  final LatLng initialLocation;

  const LocationSelectionPage({super.key, required this.initialLocation});

  @override
  _LocationSelectionPageState createState() => _LocationSelectionPageState();
}

class _LocationSelectionPageState extends State<LocationSelectionPage> {
  LatLng _selectedLocation = LatLng(0, 0); // Initial location (0, 0)

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
  }

  void _onMapTap(LatLng tappedLocation) {
    setState(() {
      _selectedLocation = tappedLocation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: _selectedLocation,
                onTap: _onMapTap,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _selectedLocation,
                      builder: (ctx) => Container(
                        child: const Icon(Icons.location_on, size: 50),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Selected Location: ${_selectedLocation.latitude}, ${_selectedLocation.longitude}',
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _selectedLocation);
              },
              child: const Text('Select'),
            ),
          ),
        ],
      ),
    );
  }
}

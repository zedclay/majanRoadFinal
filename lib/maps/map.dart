// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:latlong2/latlong.dart' as latlong;

// class CustomMarker {
//   final Marker marker;
//   final String type;
//   final String name;
//   final String description;

//   CustomMarker({
//     required this.marker,
//     required this.type,
//     required this.name,
//     required this.description,
//   });
// }

// class MapScreen extends StatefulWidget {
//   const MapScreen({Key? key}) : super(key: key);

//   @override
//   _MapScreenState createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   late MapController mapController;
//   final searchController = TextEditingController();
//   List<CustomMarker> allMarkers = [];
//   List<CustomMarker> filteredMarkers = [];

//   bool showHospitals = false;
//   bool showMosques = false;
//   bool showBanks = false;
//   bool showGasStations = false;
//   bool showHotels = false;
//   bool isDarkMode = false; // Add this variable to track dark mode state

//   @override
//   void initState() {
//     super.initState();
//     mapController = MapController();
//     allMarkers = _buildMarkers();
//     filteredMarkers = allMarkers; // Initialize with all markers shown
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }

//   void _zoomIn() {
//     mapController.move(mapController.center, mapController.zoom + 1);
//   }

//   void _zoomOut() {
//     mapController.move(mapController.center, mapController.zoom - 1);
//   }

//   void _filterMarkers() {
//     setState(() {
//       filteredMarkers = allMarkers.where((customMarker) {
//         final markerType = customMarker.type;
//         if (showHospitals && markerType == 'Hospital') return true;
//         if (showMosques && markerType == 'Mosque') return true;
//         if (showBanks && markerType == 'Bank') return true;
//         if (showGasStations && markerType == 'Gas Station') return true;
//         if (showHotels && markerType == 'Hotel') return true;
//         return false;
//       }).toList();
//     });
//   }

//   void _showMarkerDetails(CustomMarker customMarker) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(customMarker.name,
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               SizedBox(height: 8),
//               Text(customMarker.description),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   mapController.move(customMarker.marker.point, 15);
//                 },
//                 child: Text('Zoom to Marker'),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _showFilterMenu(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setModalState) {
//             return Container(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   _buildSwitchListTile('Hospitals', showHospitals, (value) {
//                     setModalState(() {
//                       showHospitals = value!;
//                     });
//                     _filterMarkers();
//                   }),
//                   _buildSwitchListTile('Mosques', showMosques, (value) {
//                     setModalState(() {
//                       showMosques = value!;
//                     });
//                     _filterMarkers();
//                   }),
//                   _buildSwitchListTile('Banks', showBanks, (value) {
//                     setModalState(() {
//                       showBanks = value!;
//                     });
//                     _filterMarkers();
//                   }),
//                   _buildSwitchListTile('Gas Stations', showGasStations,
//                       (value) {
//                     setModalState(() {
//                       showGasStations = value!;
//                     });
//                     _filterMarkers();
//                   }),
//                   _buildSwitchListTile('Hotels', showHotels, (value) {
//                     setModalState(() {
//                       showHotels = value!;
//                     });
//                     _filterMarkers();
//                   }),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   void _toggleTheme() {
//     setState(() {
//       isDarkMode = !isDarkMode;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         foregroundColor: Colors.white,
//         backgroundColor:
//             isDarkMode ? Colors.black : Color.fromARGB(255, 57, 111, 110),
//         title: const Text(
//           'Mjan Map',
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(
//               isDarkMode ? Icons.light_mode : Icons.dark_mode,
//               color: Colors.white,
//               size: 30,
//             ),
//             onPressed: _toggleTheme,
//           ),
//           IconButton(
//             icon: const Icon(
//               Icons.search,
//               color: Colors.white,
//               size: 30,
//             ),
//             onPressed: () {
//               showSearch(
//                 context: context,
//                 delegate: MarkerSearchDelegate(
//                   customMarkers: allMarkers,
//                   onQueryChanged: (query) {},
//                   mapController: mapController,
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           FlutterMap(
//             mapController: mapController,
//             options: const MapOptions(
//               center: latlong.LatLng(23.5880, 58.3829),
//               zoom: 9.2,
//             ),
//             children: [
//               TileLayer(
//                 urlTemplate: isDarkMode
//                     ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
//                     : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                 userAgentPackageName: 'com.example.app',
//               ),
//               MarkerLayer(
//                 markers: filteredMarkers.map((customMarker) {
//                   return Marker(
//                     width: 80.0,
//                     height: 80.0,
//                     point: customMarker.marker.point,
//                     child: GestureDetector(
//                       onTap: () => _showMarkerDetails(customMarker),
//                       child: customMarker.marker.child,
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ],
//             nonRotatedChildren: [
//               RichAttributionWidget(
//                 attributions: [
//                   TextSourceAttribution(
//                     'OpenStreetMap contributors',
//                     onTap: () =>
//                         _launchURL('https://openstreetmap.org/copyright'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Positioned(
//             bottom: 80,
//             right: 10,
//             child: Column(
//               children: [
//                 FloatingActionButton(
//                   mini: true,
//                   heroTag: 'zoomIn',
//                   onPressed: _zoomIn,
//                   child: const Icon(Icons.zoom_in),
//                 ),
//                 const SizedBox(height: 10),
//                 FloatingActionButton(
//                   mini: true,
//                   heroTag: 'zoomOut',
//                   onPressed: _zoomOut,
//                   child: const Icon(Icons.zoom_out),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             top: 10,
//             left: 10,
//             child: ElevatedButton(
//               onPressed: () => _showFilterMenu(context),
//               child: Text('Filter Markers'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSwitchListTile(
//       String title, bool value, ValueChanged<bool?> onChanged) {
//     return SwitchListTile(
//       title: Text(title),
//       value: value,
//       onChanged: onChanged,
//       activeColor: Color.fromARGB(255, 57, 111, 110),
//     );
//   }

//   void _launchURL(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   Marker _createMarker(
//     double lat,
//     double lng,
//     IconData icon,
//     Color color,
//     String keyString,
//   ) {
//     return Marker(
//       width: 80.0,
//       height: 80.0,
//       point: latlong.LatLng(lat, lng),
//       child: Icon(icon, color: color),
//       key: Key(keyString),
//     );
//   }

//   List<CustomMarker> _buildMarkers() {
//     return [
//       // Hospitals
//       CustomMarker(
//         marker: _createMarker(23.594953, 58.178239, Icons.local_hospital,
//             Colors.red, 'Hospital - Sultan Qaboos University Hospital'),
//         type: 'Hospital',
//         name: 'Sultan Qaboos University Hospital',
//         description: 'A major hospital offering advanced medical services.',
//       ),
//       CustomMarker(
//         marker: _createMarker(23.581707, 58.379444, Icons.local_hospital,
//             Colors.red, 'Hospital - Royal Hospital'),
//         type: 'Hospital',
//         name: 'Royal Hospital',
//         description: 'A leading hospital known for its excellent healthcare.',
//       ),
//       CustomMarker(
//         marker: _createMarker(23.614307, 58.521636, Icons.local_hospital,
//             Colors.red, 'Hospital - Khoula Hospital'),
//         type: 'Hospital',
//         name: 'Khoula Hospital',
//         description: 'A hospital specializing in trauma and orthopedics.',
//       ),
//       CustomMarker(
//         marker: _createMarker(22.939578, 57.537343, Icons.local_hospital,
//             Colors.red, 'Hospital - Nizwa Hospital'),
//         type: 'Hospital',
//         name: 'Nizwa Hospital',
//         description: 'A regional hospital serving the Nizwa area.',
//       ),
//       CustomMarker(
//         marker: _createMarker(24.371825, 56.720562, Icons.local_hospital,
//             Colors.red, 'Hospital - Sohar Hospital'),
//         type: 'Hospital',
//         name: 'Sohar Hospital',
//         description: 'A key healthcare provider in the Sohar region.',
//       ),

//       // Mosques
//       CustomMarker(
//         marker: _createMarker(23.585895, 58.405923, Icons.mosque, Colors.green,
//             'Mosque - Sultan Qaboos Grand Mosque'),
//         type: 'Mosque',
//         name: 'Sultan Qaboos Grand Mosque',
//         description:
//             'The largest mosque in Oman, known for its stunning architecture.',
//       ),
//       CustomMarker(
//         marker: _createMarker(23.611176, 58.530358, Icons.mosque, Colors.green,
//             'Mosque - Masjid Al Zawawi'),
//         type: 'Mosque',
//         name: 'Masjid Al Zawawi',
//         description: 'A beautiful mosque located in the heart of the city.',
//       ),
//       CustomMarker(
//         marker: _createMarker(23.561496, 58.289176, Icons.mosque, Colors.green,
//             'Mosque - Al Ameen Mosque'),
//         type: 'Mosque',
//         name: 'Al Ameen Mosque',
//         description: 'A peaceful place of worship with intricate designs.',
//       ),
//       CustomMarker(
//         marker: _createMarker(23.607421, 58.560934, Icons.mosque, Colors.green,
//             'Mosque - Masjid Al Khor'),
//         type: 'Mosque',
//         name: 'Masjid Al Khor',
//         description:
//             'Known for its serene environment and community activities.',
//       ),
//       CustomMarker(
//         marker: _createMarker(23.606056, 58.473887, Icons.mosque, Colors.green,
//             'Mosque - Masjid Said Bin Taimur'),
//         type: 'Mosque',
//         name: 'Masjid Said Bin Taimur',
//         description: 'A mosque with a rich history and cultural significance.',
//       ),

//       // Banks
//       CustomMarker(
//         marker: _createMarker(23.586143, 58.406392, Icons.local_atm,
//             Colors.orange, 'Bank - Bank Muscat Head Office'),
//         type: 'Bank',
//         name: 'Bank Muscat Head Office',
//         description:
//             'The headquarters of Bank Muscat, offering comprehensive banking services.',
//       ),
//       CustomMarker(
//         marker: _createMarker(23.594377, 58.383775, Icons.local_atm,
//             Colors.orange, 'Bank - Bank Dhofar'),
//         type: 'Bank',
//         name: 'Bank Dhofar',
//         description: 'A leading bank in Oman with various financial products.',
//       ),
//       CustomMarker(
//         marker: _createMarker(23.594715, 58.431402, Icons.local_atm,
//             Colors.orange, 'Bank - Oman Arab Bank'),
//         type: 'Bank',
//         name: 'Oman Arab Bank',
//         description: 'Known for its innovative banking solutions.',
//       ),
//       CustomMarker(
//         marker: _createMarker(23.615178, 58.546083, Icons.local_atm,
//             Colors.orange, 'Bank - National Bank of Oman'),
//         type: 'Bank',
//         name: 'National Bank of Oman',
//         description: 'A bank with a strong presence in the region.',
//       ),
//       CustomMarker(
//         marker: _createMarker(23.598644, 58.421201, Icons.local_atm,
//             Colors.orange, 'Bank - Bank Nizwa'),
//         type: 'Bank',
//         name: 'Bank Nizwa',
//         description: 'Oman\'s first dedicated Islamic bank.',
//       ),

//       // Gas Stations
//       CustomMarker(
//         marker: _createMarker(23.588541, 58.419401, Icons.local_gas_station,
//             Colors.blue, 'Gas Station - Shell Oman Al Khuwair'),
//         type: 'Gas Station',
//         name: 'Shell Oman Al Khuwair',
//         description: 'A Shell gas station providing quality fuel and services.',
//       ),
//       CustomMarker(
//         marker: _createMarker(23.605937, 58.145064, Icons.local_gas_station,
//             Colors.blue, 'Gas Station - Oman Oil Al Khoudh'),
//         type: 'Gas Station',
//         name: 'Oman Oil Al Khoudh',
//         description:
//             'Offering a variety of fuel options and convenience services.',
//       ),
//       CustomMarker(
//         marker: _createMarker(23.604173, 58.542421, Icons.local_gas_station,
//             Colors.blue, 'Gas Station - Al Maha Petroleum Ruwi'),
//         type: 'Gas Station',
//         name: 'Al Maha Petroleum Ruwi',
//         description: 'Known for its customer-friendly services.',
//       ),
//       CustomMarker(
//         marker: _createMarker(23.612293, 58.257326, Icons.local_gas_station,
//             Colors.blue, 'Gas Station - Shell Oman Al Hail'),
//         type: 'Gas Station',
//         name: 'Shell Oman Al Hail',
//         description: 'Providing high-quality fuel and excellent service.',
//       ),
//       CustomMarker(
//         marker: _createMarker(23.603874, 58.303472, Icons.local_gas_station,
//             Colors.blue, 'Gas Station - Al Maha Petroleum Azaiba'),
//         type: 'Gas Station',
//         name: 'Al Maha Petroleum Azaiba',
//         description: 'A convenient stop for fuel and refreshments.',
//       ),

//       // Hotels
//       CustomMarker(
//         marker: _createMarker(23.507906, 58.658510, Icons.hotel, Colors.purple,
//             'Hotel - Shangri-La Barr Al Jissah Resort'),
//         type: 'Hotel',
//         name: 'Shangri-La Barr Al Jissah Resort',
//         description: 'A luxurious resort with stunning sea views.',
//       ),
//       CustomMarker(
//         marker: _createMarker(23.588834, 58.395621, Icons.hotel, Colors.purple,
//             'Hotel - Grand Millennium Muscat'),
//         type: 'Hotel',
//         name: 'Grand Millennium Muscat',
//         description: 'Offering modern amenities and excellent service.',
//       ),
//       CustomMarker(
//         marker: _createMarker(23.601368, 58.470336, Icons.hotel, Colors.purple,
//             'Hotel - Crowne Plaza Muscat'),
//         type: 'Hotel',
//         name: 'Crowne Plaza Muscat',
//         description: 'A comfortable stay with beautiful views.',
//       ),
//       CustomMarker(
//         marker: _createMarker(23.601691, 58.367264, Icons.hotel, Colors.purple,
//             'Hotel - The Chedi Muscat'),
//         type: 'Hotel',
//         name: 'The Chedi Muscat',
//         description: 'A beachfront hotel with luxurious amenities.',
//       ),
//       CustomMarker(
//         marker: _createMarker(23.555361, 58.641522, Icons.hotel, Colors.purple,
//             'Hotel - Al Bustan Palace, A Ritz-Carlton Hotel'),
//         type: 'Hotel',
//         name: 'Al Bustan Palace, A Ritz-Carlton Hotel',
//         description: 'A premier hotel offering world-class services.',
//       ),
//     ];
//   }
// }

// class MarkerSearchDelegate extends SearchDelegate {
//   final List<CustomMarker> customMarkers;
//   final Function(String) onQueryChanged;
//   final MapController mapController;

//   MarkerSearchDelegate({
//     required this.customMarkers,
//     required this.onQueryChanged,
//     required this.mapController,
//   });

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: const Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//           onQueryChanged(query);
//           showSuggestions(context); // Reset suggestions
//         },
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, null);
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return _buildMarkerList();
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     onQueryChanged(query);
//     return _buildMarkerList();
//   }

//   Widget _buildMarkerList() {
//     final results = customMarkers.where((customMarker) {
//       final markerName = customMarker.name.toLowerCase();
//       final searchLower = query.toLowerCase();
//       return markerName.contains(searchLower);
//     }).toList();

//     return ListView.builder(
//       itemCount: results.length,
//       itemBuilder: (context, index) {
//         final customMarker = results[index];
//         return ListTile(
//           title: Text(customMarker.name),
//           subtitle: Text(customMarker.description),
//           onTap: () {
//             close(context, null);
//             final latlng = customMarker.marker.point;
//             mapController.move(
//                 latlng, 15); // Adjust zoom level to focus on marker
//           },
//         );
//       },
//     );
//   }
// }
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapController mapController;
  final searchController = TextEditingController();
  final GeocodingService geocodingService = GeocodingService(
      apiKey:
          'pk.eyJ1IjoiemVkY2xheSIsImEiOiJjbHgycDcwcDUwcmozMmlzOXA3YjFycXFrIn0.NiRdCKnK8iRFkB-9U61L5g'); // Replace with your API key
  List<String> suggestions = [];
  List<CustomMarker> allMarkers = [];
  List<CustomMarker> filteredMarkers = [];

  Map<String, bool> categoryFilters = {};

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _fetchMarkers(); // Fetch markers from the API
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _fetchMarkers() async {
    final response = await Dio().get('http://167.71.230.108/api/maps');
    if (response.statusCode == 200) {
      final data = response.data as List;
      setState(() {
        allMarkers = data
            .map((item) => CustomMarker(
                  marker: _createMarker(
                    double.parse(item['latitude']),
                    double.parse(item['longitude']),
                    _getIconForCategory(item['category']),
                    _getColorForCategory(item['category']),
                    item['name'],
                    item['description'] ?? '', // Add description if available
                  ),
                  type: item['category'],
                  name: item['name'],
                  description:
                      item['description'] ?? '', // Add description if available
                ))
            .toList();

        filteredMarkers = allMarkers;

        // Extract unique categories from data and initialize filters
        final categories = data.map((item) => item['category']).toSet();
        categoryFilters = {
          for (var category in categories) category: true,
        };
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load markers')),
      );
    }
  }

  void _searchPlace(String place) async {
    final latlng = await geocodingService.getCoordinates(place);
    if (latlng != null) {
      mapController.move(latlng, 8); // Adjusted zoom level for search result
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Place not found')),
      );
    }
  }

  void _getSuggestions(String query) async {
    final results = await geocodingService.getSuggestions(query);
    setState(() {
      suggestions = results;
    });
  }

  void _filterMarkers() {
    setState(() {
      filteredMarkers = allMarkers.where((customMarker) {
        return categoryFilters[customMarker.type] ?? false;
      }).toList();
    });
  }

  void _showFilterMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: categoryFilters.keys.map((category) {
                  return _buildSwitchListTile(
                      category, categoryFilters[category]!, (value) {
                    setModalState(() {
                      categoryFilters[category] = value!;
                    });
                    _filterMarkers();
                  });
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSwitchListTile(
      String title, bool currentValue, ValueChanged<bool?> onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: currentValue,
      onChanged: onChanged,
    );
  }

  Marker _createMarker(double lat, double lng, IconData icon, Color color,
      String label, String description) {
    return Marker(
      width: 80.0,
      height: 80.0,
      point: LatLng(lat, lng),
      child: Column(
        children: [
          IconButton(
            icon: Icon(icon, color: Colors.red, size: 30),
            onPressed: () =>
                _showMarkerDetails(context, label, description, lat, lng),
          ),
          Flexible(
            child: Text(
              label,
              style: TextStyle(color: color, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showMarkerDetails(BuildContext context, String name, String description,
      double lat, double lng) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(description),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('Open in Maps'),
              onPressed: () {
                final url =
                    'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
                launchUrl(Uri.parse(url));
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Close'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'place':
        return Icons.place;
      case 'Hospital':
        return Icons.local_hospital;
      case 'Mosque':
        return Icons.mosque;
      case 'Bank':
        return Icons.local_atm;
      case 'Gas Station':
        return Icons.local_gas_station;
      case 'Hotel':
        return Icons.hotel;
      default:
        return Icons.place;
    }
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Hospital':
        return Colors.red;
      case 'Mosque':
        return Colors.green;
      case 'Bank':
        return Colors.orange;
      case 'Gas Station':
        return Colors.blue;
      case 'Hotel':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          'Search Map',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 57, 111, 110),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showFilterMenu(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: LatLng(23.5880, 58.3829), // Coordinates for Muscat, Oman
              zoom: 6.0, // Adjusted initial zoom level for broader view of Oman
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/zedclay/clx2pso0301o901pn0kkfd464/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiemVkY2xheSIsImEiOiJjbHgycDcwcDUwcmozMmlzOXA3YjFycXFrIn0.NiRdCKnK8iRFkB-9U61L5g',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: filteredMarkers
                    .map((customMarker) => customMarker.marker)
                    .toList(),
              ),
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () => launchUrl(
                        Uri.parse('https://openstreetmap.org/copyright')),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.search),
                    title: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Enter a place name',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) => _getSuggestions(value),
                      onSubmitted: (value) => _searchPlace(value),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        setState(() {
                          suggestions = [];
                        });
                      },
                    ),
                  ),
                  if (suggestions.isNotEmpty)
                    Container(
                      height: 100,
                      child: ListView.builder(
                        itemCount: suggestions.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(suggestions[index]),
                            onTap: () {
                              searchController.text = suggestions[index];
                              _searchPlace(suggestions[index]);
                              setState(() {
                                suggestions = [];
                              });
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            right: 10,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    mapController.move(
                        mapController.center, mapController.zoom + 1);
                  },
                  child: Icon(Icons.zoom_in),
                ),
                SizedBox(height: 8),
                FloatingActionButton(
                  onPressed: () {
                    mapController.move(
                        mapController.center, mapController.zoom - 1);
                  },
                  child: Icon(Icons.zoom_out),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomMarker {
  final Marker marker;
  final String type;
  final String name;
  final String description;

  CustomMarker({
    required this.marker,
    required this.type,
    required this.name,
    required this.description,
  });
}

class GeocodingService {
  final String apiKey;
  final Dio _dio = Dio();

  GeocodingService({required this.apiKey});

  Future<LatLng?> getCoordinates(String place) async {
    final url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$place.json?access_token=$apiKey';
    final response = await _dio.get(url);
    if (response.statusCode == 200) {
      final data = response.data;
      if (data['features'].isNotEmpty) {
        final coordinates = data['features'][0]['geometry']['coordinates'];
        return LatLng(coordinates[1], coordinates[0]);
      }
    }
    return null;
  }

  Future<List<String>> getSuggestions(String query) async {
    final url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?access_token=$apiKey';
    final response = await _dio.get(url);
    if (response.statusCode == 200) {
      final data = response.data;
      return (data['features'] as List)
          .map((feature) => feature['place_name'] as String)
          .toList();
    }
    return [];
  }
}

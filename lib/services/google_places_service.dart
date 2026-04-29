import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers/store_provider.dart';

class GooglePlacesService {
  // We use Overpass API (OpenStreetMap) because it's FREE and doesn't require an API Key instantly
  // This will fetch REAL shops around a location.
  
  static Future<List<Store>> fetchNearbyRealStores(double lat, double lon) async {
    final query = """
    [out:json];
    (
      node["shop"~"supermarket|bakery|convenience|butcher|clothes|electronics|data|mobile_phone|pharmacy|mall"](around:10000, $lat, $lon);
      node["amenity"~"restaurant|cafe|fast_food|pharmacy|bank|fuel|hospital"](around:10000, $lat, $lon);
    );
    out body;
    """;

    final encodedQuery = Uri.encodeComponent(query);
    final url = Uri.parse('https://overpass-api.de/api/interpreter?data=$encodedQuery');

    try {
      print('Fetching real stores from: $url');
      final response = await http.get(url).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List elements = data['elements'] ?? [];
        print('Found ${elements.length} real stores');
        
        return elements.map((e) {
          final tags = e['tags'] ?? {};
          final String shopType = tags['shop'] ?? tags['amenity'] ?? 'shop';
          return Store(
            id: 'real_${e['id']}',
            name: tags['name'] ?? tags['shop'] ?? tags['amenity'] ?? 'متجر حقيقي',
            category: _mapCategory(shopType),
            latitude: (e['lat'] as num).toDouble(),
            longitude: (e['lon'] as num).toDouble(),
            description: 'متجر حقيقي من الخرائط العالمية',
            isRealLocation: true,
          );
        }).toList();
      } else {
        print('Overpass API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching real stores: $e');
    }
    return [];
  }

  static String _mapCategory(String? type) {
    if (type == null) return 'متجر';
    switch (type) {
      case 'supermarket': return 'بقالة وسوبر ماركت';
      case 'bakery': return 'مخبزة وحلويات';
      case 'butcher': return 'لحوم ودواجن';
      case 'pharmacy': return 'صيدلية 🏥';
      case 'restaurant': return 'مطعم 🍕';
      case 'cafe': return 'مقاهي ☕';
      case 'fast_food': return 'أكل سريع 🍔';
      case 'bank': return 'بنك 🏦';
      case 'fuel': return 'محطة وقود ⛽';
      case 'clothes': return 'ملابس وموضة 👕';
      case 'electronics': return 'إلكترونيات 💻';
      case 'mobile_phone': return 'هواتف ونقالات 📱';
      case 'mall': return 'مركز تجاري 🏢';
      case 'hospital': return 'مستشفى 🏥';
      default: return 'نشاط تجاري';
    }
  }
}

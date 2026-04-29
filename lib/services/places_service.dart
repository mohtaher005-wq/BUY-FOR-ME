import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

// ─────────────────────────────────────────────
// MODEL: NearbyPlace
// ─────────────────────────────────────────────

class NearbyPlace {
  final String placeId;
  final String name;
  final String? vicinity;
  final double latitude;
  final double longitude;
  final String? photoReference;
  final double? rating;
  final int? userRatingsTotal;
  final bool isOpen;
  final List<String> types;

  const NearbyPlace({
    required this.placeId,
    required this.name,
    this.vicinity,
    required this.latitude,
    required this.longitude,
    this.photoReference,
    this.rating,
    this.userRatingsTotal,
    this.isOpen = true,
    this.types = const [],
  });

  factory NearbyPlace.fromJson(Map<String, dynamic> json) {
    final geo = json['geometry']?['location'] ?? {};
    final openNow = json['opening_hours']?['open_now'] ?? true;
    final photos = json['photos'] as List?;
    final types = (json['types'] as List?)?.cast<String>() ?? [];
    return NearbyPlace(
      placeId: json['place_id'] ?? '',
      name: json['name'] ?? '',
      vicinity: json['vicinity'],
      latitude: (geo['lat'] ?? 0).toDouble(),
      longitude: (geo['lng'] ?? 0).toDouble(),
      photoReference: photos?.isNotEmpty == true
          ? photos!.first['photo_reference']
          : null,
      rating: json['rating']?.toDouble(),
      userRatingsTotal: json['user_ratings_total'],
      isOpen: openNow,
      types: types,
    );
  }

  String get categoryAr {
    if (types.contains('supermarket')) return 'سوبرماركت';
    if (types.contains('grocery_or_supermarket')) return 'بقالة';
    if (types.contains('convenience_store')) return 'متجر محلي';
    if (types.contains('bakery')) return 'مخبزة';
    if (types.contains('pharmacy')) return 'صيدلية';
    if (types.contains('restaurant')) return 'مطعم';
    if (types.contains('cafe')) return 'مقهى';
    if (types.contains('clothing_store')) return 'ملابس';
    if (types.contains('electronics_store')) return 'إلكترونيات';
    if (types.contains('book_store')) return 'مكتبة';
    if (types.contains('hardware_store')) return 'أدوات';
    if (types.contains('shoe_store')) return 'أحذية';
    if (types.contains('jewelry_store')) return 'مجوهرات';
    if (types.contains('shopping_mall')) return 'مركز تجاري';
    return 'متجر';
  }

  String? photoUrl(String apiKey, {int maxWidth = 400}) {
    if (photoReference == null) return null;
    return 'https://maps.googleapis.com/maps/api/place/photo'
        '?maxwidth=$maxWidth&photoreference=$photoReference&key=$apiKey';
  }
}

// ─────────────────────────────────────────────
// MODEL: RouteInfo
// ─────────────────────────────────────────────

class RouteInfo {
  final List<LatLng> points;
  final double distanceMeters;
  final int durationSeconds;

  const RouteInfo({
    required this.points,
    required this.distanceMeters,
    required this.durationSeconds,
  });

  String get distanceText {
    if (distanceMeters < 1000) return '${distanceMeters.round()} م';
    return '${(distanceMeters / 1000).toStringAsFixed(1)} كم';
  }

  String get durationText {
    if (durationSeconds < 60) return '$durationSeconds ث';
    final mins = (durationSeconds / 60).round();
    if (mins < 60) return '$mins دقيقة';
    final hours = mins ~/ 60;
    final remaining = mins % 60;
    return '$hours س ${remaining > 0 ? "$remaining دقيقة" : ""}';
  }
}

// ─────────────────────────────────────────────
// SERVICE
// ─────────────────────────────────────────────

class PlacesService {
  /// ⚠️ Replace with your real Google Cloud API key
  /// (Enable: Places API, Directions API, Maps Static API)
  static const String apiKey = 'YOUR_GOOGLE_PLACES_API_KEY';

  static const _placesBase =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

  // ── Nearby Stores ──────────────────────────

  static Future<List<NearbyPlace>> fetchNearbyStores({
    required double lat,
    required double lng,
    int radiusMeters = 2000,
    String type = 'store',
    String? pageToken,
  }) async {
    final params = {
      'location': '$lat,$lng',
      'radius': '$radiusMeters',
      'type': type,
      'key': apiKey,
      'pagetoken': ?pageToken,
    };

    try {
      final uri = Uri.parse(_placesBase).replace(queryParameters: params);
      final resp = await http.get(uri).timeout(const Duration(seconds: 10));
      if (resp.statusCode != 200) return [];

      final data = json.decode(resp.body);
      final status = data['status'] as String?;
      if (status != 'OK' && status != 'ZERO_RESULTS') {
        debugPrint(
          'Places API [$type] status=$status msg=${data['error_message']}',
        );
        return [];
      }

      final results = (data['results'] as List? ?? [])
          .map((e) => NearbyPlace.fromJson(e))
          .toList();

      final nextToken = data['next_page_token'] as String?;
      if (nextToken != null && results.length >= 20) {
        await Future.delayed(const Duration(seconds: 2));
        final more = await fetchNearbyStores(
          lat: lat,
          lng: lng,
          radiusMeters: radiusMeters,
          type: type,
          pageToken: nextToken,
        );
        results.addAll(more);
      }
      return results;
    } catch (e) {
      debugPrint('Places API error: $e');
      return [];
    }
  }

  /// Fetch multiple types and deduplicate by placeId
  static Future<List<NearbyPlace>> fetchAllNearbyStores({
    required double lat,
    required double lng,
    int radiusMeters = 2000,
  }) async {
    const types = [
      'supermarket',
      'grocery_or_supermarket',
      'store',
      'shopping_mall',
    ];

    final all = <NearbyPlace>[];
    final seen = <String>{};

    for (final t in types) {
      final places = await fetchNearbyStores(
        lat: lat,
        lng: lng,
        radiusMeters: radiusMeters,
        type: t,
      );
      for (final p in places) {
        if (seen.add(p.placeId)) all.add(p);
      }
    }

    all.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
    return all;
  }

  // ── Text Search (for search bar) ───────────

  static Future<List<NearbyPlace>> searchPlaces({
    required String query,
    required double lat,
    required double lng,
    int radiusMeters = 5000,
  }) async {
    if (query.trim().isEmpty) return [];

    final params = {
      'query': query,
      'location': '$lat,$lng',
      'radius': '$radiusMeters',
      'type': 'store',
      'key': apiKey,
    };

    try {
      const url = 'https://maps.googleapis.com/maps/api/place/textsearch/json';
      final uri = Uri.parse(url).replace(queryParameters: params);
      final resp = await http.get(uri).timeout(const Duration(seconds: 8));
      if (resp.statusCode != 200) return [];

      final data = json.decode(resp.body);
      if (data['status'] != 'OK') return [];

      return (data['results'] as List)
          .map((e) => NearbyPlace.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint('Text search error: $e');
      return [];
    }
  }

  // ── Routing via OSRM (FREE – no API key) ───

  /// Returns the walking/driving route between two coordinates using
  /// the free OSRM public server.
  static Future<RouteInfo?> getRoute({
    required LatLng origin,
    required LatLng destination,
    String profile = 'driving', // 'driving' | 'walking' | 'cycling'
  }) async {
    final url =
        'https://router.project-osrm.org/route/v1/$profile/'
        '${origin.longitude},${origin.latitude};'
        '${destination.longitude},${destination.latitude}'
        '?overview=full&geometries=geojson&steps=false';

    try {
      final resp = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));
      if (resp.statusCode != 200) return null;

      final data = json.decode(resp.body);
      final routes = data['routes'] as List?;
      if (routes == null || routes.isEmpty) return null;

      final route = routes.first;
      final distanceM = (route['distance'] as num).toDouble();
      final durationS = (route['duration'] as num).round();

      final coords = route['geometry']['coordinates'] as List;
      final points = coords
          .map(
            (c) => LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()),
          )
          .toList();

      return RouteInfo(
        points: points,
        distanceMeters: distanceM,
        durationSeconds: durationS,
      );
    } catch (e) {
      debugPrint('OSRM routing error: $e');
      return null;
    }
  }

  // ── Helpers ─────────────────────────────────

  /// Haversine distance in meters between two points
  static double distanceBetween(LatLng a, LatLng b) {
    const r = 6371000.0;
    final lat1 = a.latitude * math.pi / 180;
    final lat2 = b.latitude * math.pi / 180;
    final dLat = (b.latitude - a.latitude) * math.pi / 180;
    final dLon = (b.longitude - a.longitude) * math.pi / 180;
    final sinA = math.sin(dLat / 2);
    final sinB = math.sin(dLon / 2);
    final x = sinA * sinA + math.cos(lat1) * math.cos(lat2) * sinB * sinB;
    return r * 2 * math.atan2(math.sqrt(x), math.sqrt(1 - x));
  }

  static String formatDistance(double meters) {
    if (meters < 1000) return '${meters.round()} م';
    return '${(meters / 1000).toStringAsFixed(1)} كم';
  }
}

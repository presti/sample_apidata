import 'package:url_launcher/url_launcher.dart' as la;

class MapService {
  static const MapService i = MapService._();

  const MapService._();

  Future<bool> open(double lat, double lng) async {
    try {
      final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
      final uri = Uri.parse(url);
      await la.launchUrl(uri);
    } catch (e) {
      return false;
    }
    return true;
  }
}

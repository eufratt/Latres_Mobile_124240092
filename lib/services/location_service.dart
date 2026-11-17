import 'package:geolocator/geolocator.dart';

class LocationService {
  // Throws String message on failure.
  static Future<Position> current() async {
    if (!await Geolocator.isLocationServiceEnabled()) throw 'GPS tidak aktif';
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) perm = await Geolocator.requestPermission();
    if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
      throw 'Izin lokasi ditolak';
    }
    return Geolocator.getCurrentPosition();
  }
}

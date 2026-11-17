import 'dart:convert';
import 'package:http/http.dart' as http;

// Fetch + parse API, dipisah dari UI.
class TvMazeService {
  static const _base = 'https://api.tvmaze.com';

  static Future<List<Map<String, dynamic>>> fetchShows() async {
    final res = await http.get(Uri.parse('$_base/shows'));
    if (res.statusCode != 200) throw Exception('Gagal memuat data (${res.statusCode})');
    return (jsonDecode(res.body) as List).cast<Map<String, dynamic>>();
  }

  static Future<Map<String, dynamic>> fetchShow(int id) async {
    final res = await http.get(Uri.parse('$_base/shows/$id'));
    if (res.statusCode != 200) throw Exception('Gagal memuat detail (${res.statusCode})');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }
}

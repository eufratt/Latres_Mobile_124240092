import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoriteService {
  static const _name = 'favorites';
  static Box get _box => Hive.box(_name);

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_name);
  }

  static ValueListenable<Box> listenable() => _box.listenable();
  static bool isFav(int id) => _box.containsKey(id);
  static List<Map<String, dynamic>> all() =>
      _box.values.map((e) => Map<String, dynamic>.from(e as Map)).toList();

  static Future<void> toggle(int id, String name, String? image, num? rating) async {
    if (isFav(id)) {
      await _box.delete(id);
    } else {
      await _box.put(id, {'id': id, 'name': name, 'image': image, 'rating': rating});
    }
  }

  static Future<void> remove(int id) => _box.delete(id);
}

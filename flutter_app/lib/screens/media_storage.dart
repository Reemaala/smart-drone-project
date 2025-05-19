import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class MediaStorage {
  static const _key = 'saved_media';

  /// Save image or video path with optional location and thumbnail
  static Future<void> addMediaPath({
    required String type, // 'image' or 'video'
    required String path,
    double? lat,
    double? lon,
    String? thumbnailPath, // Only used for videos
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final currentList = prefs.getStringList(_key) ?? [];

    final entry = '$type|$path|${lat ?? ''}|${lon ?? ''}|${thumbnailPath ?? ''}';
    currentList.insert(0, entry);

    await prefs.setStringList(_key, currentList);
  }

  /// Load all saved media entries as a list of maps
  static Future<List<Map<String, dynamic>>> loadImagePaths() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_key) ?? [];

    return rawList.map((entry) {
      final parts = entry.split('|');
      return {
        'type': parts.isNotEmpty ? parts[0] : 'image',
        'path': parts.length > 1 ? parts[1] : '',
        'lat': parts.length > 2 ? double.tryParse(parts[2]) : null,
        'lon': parts.length > 3 ? double.tryParse(parts[3]) : null,
        'thumbnail': parts.length > 4 && parts[4].isNotEmpty ? parts[4] : null,
      };
    }).toList();
  }

  /// Remove a single media entry using its path
  static Future<void> removeMediaPath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    final currentList = prefs.getStringList(_key) ?? [];

    String? thumbnailToDelete;

    currentList.removeWhere((entry) {
      final parts = entry.split('|');
      if (parts.length > 1 && parts[1] == path) {
        if (parts.length > 4 && parts[4].isNotEmpty) {
          thumbnailToDelete = parts[4];
        }
        return true;
      }
      return false;
    });

    await prefs.setStringList(_key, currentList);

    // Optional: delete the media and thumbnail files
    final mediaFile = File(path);
    if (await mediaFile.exists()) {
      await mediaFile.delete();
    }

    if (thumbnailToDelete != null) {
      final thumbFile = File(thumbnailToDelete!);
      if (await thumbFile.exists()) {
        await thumbFile.delete();
      }
    }
  }

  /// Clear all saved media (reset)
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}









import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../core/network/exceptions.dart';

abstract class FavoritesLocalDataSource {
  Future<List<int>> getFavoriteIds();
  Future<void> saveFavoriteIds(List<int> ids);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final Box box;

  FavoritesLocalDataSourceImpl({required this.box});

  @override
  Future<List<int>> getFavoriteIds() async {
    try {
      final data = box.get(AppConstants.favoritesKey);
      if (data == null) return [];
      return List<int>.from(data as List);
    } catch (_) {
      throw const CacheException(
          'Failed to read favorites from local storage.');
    }
  }

  @override
  Future<void> saveFavoriteIds(List<int> ids) async {
    try {
      await box.put(AppConstants.favoritesKey, ids);
    } catch (_) {
      throw const CacheException(
          'Failed to save favorites to local storage.');
    }
  }
}
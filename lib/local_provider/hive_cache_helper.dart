import 'package:hive/hive.dart';
import '../models/movie_hive_model.dart';
import '../models/movie_list_cache_model.dart';
class HiveCacheHelper{
  static const Duration cacheDuration=Duration(minutes: 5);
  static Future<Box<MovieListCacheModel>>openBox(String boxName)async{
    return await Hive.openBox<MovieListCacheModel>(boxName);
  }
  static Future<void> cacheMovies({required  String boxName,required List<MovieModel> movies}) async {
    final box = await openBox(boxName);
    final data = MovieListCacheModel(
      movies: movies,
      cachedAt: DateTime.now(),
    );
    await box.put('data', data);
  }
  static Future<List<MovieModel>?> getCachedMovies({required String boxName}) async {
    final box = await openBox(boxName);
    final data = box.get('data');

    if (data != null) {
      final isExpired = DateTime.now().difference(data.cachedAt) > cacheDuration;
      if (!isExpired) return data.movies;
    }
    return null;
  }
  static Future<bool> hasValidCache(String boxName) async {
    final box = await openBox(boxName);
    final data = box.get('data');

    if (data != null) {
      final isExpired = DateTime.now().difference(data.cachedAt) > cacheDuration;
      return !isExpired;
    }
    return false;
  }
}
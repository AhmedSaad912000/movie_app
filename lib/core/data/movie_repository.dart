import 'package:hive/hive.dart';
import 'package:movie_app/core/util/dio_helper.dart';
import 'package:movie_app/models/popular_movies_model.dart';
import 'package:movie_app/models/top_rated_movie_model.dart';
import 'package:movie_app/models/upcoming_movies_model.dart';
import 'package:movie_app/models/show_favorite_movies_model.dart';
import 'package:movie_app/models/details_movie_model.dart';
import '../../local_provider/hive_cache_helper.dart';
import '../../models/movie_hive_model.dart';
import '../error/app_exception.dart';
import 'movie_repository_base.dart';
enum MovieType { popular, upcoming, topRated }

class MovieRepositoryImpl implements MovieRepositoryBase {
  // ⭐ 1. Fetch movies with caching
  Future<List<MovieModel>> fetchMovies(MovieType type,{int page = 1}) async {
    final config = _getConfig(type);

    final cached = await HiveCacheHelper.getCachedMovies(config.boxName);
    if (cached != null) {
      print("✅ Fetched from cache");
      return cached;
    }

    final response = await DioHelper.get(config.endpoint,data: {
    'page': page},);
    if (response.isSuccess) {
      final list = config.extractList(response.data);
      await HiveCacheHelper.cacheMovies(config.boxName, list);
      print("🌐 Fetched from API and cached");
      return list;
    } else {
      throw AppException(response.msg);
    }
  }

  _RepositoryConfig _getConfig(MovieType type) {
    switch (type) {
      case MovieType.popular:
        return _RepositoryConfig(
          endpoint: 'movie/popular',
          boxName: 'popularMoviesBox',
          extractList: (json) => PopularMoviesData.fromJson(json).list,
        );
      case MovieType.upcoming:
        return _RepositoryConfig(
          endpoint: 'movie/upcoming',
          boxName: 'upcomingMoviesBox',
          extractList: (json) => UpcomingMovieData.fromJson(json).list,
        );
      case MovieType.topRated:
        return _RepositoryConfig(
          endpoint: 'movie/top_rated',
          boxName: 'topRatedMoviesBox',
          extractList: (json) => TopRatedMoviesData.fromJson(json).list,
        );
    }
  }

  // ⭐ 2. Filter by genre
  Future<List<MovieModel>> filterByGenre({
    required int genreId,
    required MovieType type,
  }) async {
    final config = _getConfig(type);

    final response = await DioHelper.get('discover/movie', data: {
      'with_genres': genreId,
    });

    if (response.isSuccess) {
      return config.extractList(response.data);
    } else {
      throw AppException('فشل في تحميل أفلام النوع');
    }
  }

  // ⭐ 3. Get movie details (no caching)
  Future<DetailsMovieData> getMovieDetailsFromApi(int id) async {
    final response = await DioHelper.get('movie/$id');

    if (response.isSuccess) {
      return DetailsMovieData.fromJson(response.data);
    } else {
      throw AppException(response.msg);
    }
  }

  // ⭐ 4. Get similar movies with caching
  Future<List<MovieModel>> getSimilarMovies(int movieId) async {
    final box = await Hive.openBox<List<MovieModel>>('similar_movies_box');
    final key = 'similar_$movieId';

    final cached = box.get(key);
    if (cached != null) {
      return cached;
    }

    final response = await DioHelper.get('movie/$movieId/similar');
    if (response.isSuccess) {
      final list = PopularMoviesData.fromJson(response.data).list;
      await box.put(key, list);
      print("🌐 Similar movies from API");
      return list;
    } else {
      throw AppException(response.msg);
    }
  }

  // ⭐ 5. Favorites (Hive local)
  Future<void> toggleFavorite(MovieModel movie) async {
    final box = await Hive.openBox<MovieModel>('favoritesBox');
    if (box.containsKey(movie.id)) {
      await box.delete(movie.id);
      print("🗑 Removed from favorites");
    } else {
      await box.put(movie.id, movie);
      print("❤️ Added to favorites");
    }
  }

  Future<bool> isFavorite(int movieId) async {
    final box = await Hive.openBox<MovieModel>('favoritesBox');
    return box.containsKey(movieId);
  }

  Future<List<MovieModel>> getFavoriteMovies() async {
    final box = await Hive.openBox<MovieModel>('favoritesBox');
    return box.values.toList();
  }

  // ⭐ 6. Favorites (TMDb API)
  Future<bool> markFavorite({
    required int movieId,
    required bool isFavorite,
  }) async {
    final response = await DioHelper.post('account/22093634/favorite', data: {
      "media_type": "movie",
      "media_id": movieId,
      "favorite": isFavorite,
    });

    if (response.isSuccess) {
      return true;
    } else {
      throw AppException(response.msg);
    }
  }

  Future<List<ShowFavoriteMovieModel>> getFavoriteMoviesFromApi() async {
    final response = await DioHelper.get('account/22093634/favorite/movies');

    if (response.isSuccess) {
      final model = ShowFavoriteMoviesData.fromJson(response.data);
      return model.list;
    } else {
      throw AppException(response.msg);
    }
  }
}

class _RepositoryConfig {
  final String endpoint;
  final String boxName;
  final List<MovieModel> Function(Map<String, dynamic>) extractList;

  _RepositoryConfig({
    required this.endpoint,
    required this.boxName,
    required this.extractList,
  });
}

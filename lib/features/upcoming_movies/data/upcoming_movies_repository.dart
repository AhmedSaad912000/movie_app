import 'package:movie_app/core/data/dio_helper.dart';
import 'package:movie_app/features/upcoming_movies/data/upcoming_movies_repo_base.dart';
import 'package:hive/hive.dart';
import '../../../local_provider/movie_hive_model.dart';

class UpcomingMoviesRepoImpl implements UpcomingMoviesRepo {
  Box<MovieModel>? _hiveBox;

  Future<Box<MovieModel>> get _box async {
    if (_hiveBox == null || !_hiveBox!.isOpen) {
      _hiveBox = await Hive.openBox<MovieModel>('upcomingMovies');
    }
    return _hiveBox!;
  }

  @override
  Future<List<MovieModel>> fetchUpcomingMovies({int page = 1}) async {
    final response = await DioHelper.get('/movie/upcoming', data: {'page': page});
    final results = response.data['results'] as List;
    return results.map((json) => MovieModel.fromJson(json)).toList();
  }

  @override
  Future<void> cacheUpcomingMovies(List<MovieModel> movies) async {
    final box = await _box;
    await box.clear();
    for (var movie in movies) {
      await box.put(movie.id, movie);
    }
  }

  @override
  Future<List<MovieModel>> getCachedUpcomingMovies() async {
    final box = await _box;
    return box.values.toList();
  }

  @override
  Future<void> clearCachedUpcomingMovies() async {
    final box = await _box;
    await box.clear();
  }
}

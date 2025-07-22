import 'package:hive/hive.dart';
import 'package:movie_app/core/data/dio_helper.dart';
import 'package:movie_app/features/top_rated_movies/data/top_rated_movies_repo_base.dart';
import '../../../local_provider/movie_hive_model.dart';

class TopRatedMoviesRepoImpl implements TopRatedMoviesRepo {
  Box<MovieModel>? _hiveBox;

  Future<Box<MovieModel>> get _box async {
    if (_hiveBox == null || !_hiveBox!.isOpen) {
      _hiveBox = await Hive.openBox<MovieModel>('topRatedMovies'); // اسم مختلف عن البوكسات التانية
    }
    return _hiveBox!;
  }

  @override
  Future<List<MovieModel>> fetchTopRatedMovies({int page = 1}) async {
    final response = await DioHelper.get('/movie/top_rated', data: {'page': page});
    final results = response.data['results'] as List;
    return results.map((json) => MovieModel.fromJson(json)).toList();
  }

  @override
  Future<void> cacheTopRatedMovies(List<MovieModel> movies) async {
    final box = await _box;
    await box.clear();
    for (var movie in movies) {
      await box.put(movie.id, movie);
    }
  }

  @override
  Future<List<MovieModel>> getCachedTopRatedMovies() async {
    final box = await _box;
    return box.values.toList();
  }

  @override
  Future<void> clearCachedTopRatedMovies() async {
    final box = await _box;
    await box.clear();
  }
}

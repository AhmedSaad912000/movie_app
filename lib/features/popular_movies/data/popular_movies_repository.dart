import 'package:movie_app/core/data/dio_helper.dart';
import 'package:movie_app/features/popular_movies/data/popular_movies_repo_base.dart';
import 'package:hive/hive.dart';
import '../../../core/widgets/app_exception.dart';
import '../../../local_provider/movie_hive_model.dart';

class PopularMoviesRepoImpl implements PopularMoviesRepo {
  Box<MovieModel>? _hiveBox;

  Future<Box<MovieModel>> get _box async {
    if (_hiveBox == null || !_hiveBox!.isOpen) {
      _hiveBox = await Hive.openBox<MovieModel>('popularMovies');
    }
    return _hiveBox!;
  }

  @override
  Future<List<MovieModel>> fetchPopularMovies({int page = 1}) async {
    try{
      final response = await DioHelper.get('/movie/popular', data: {'page': page});
      final results = response.data['results'] as List;
      return results.map((json) => MovieModel.fromJson(json)).toList();
    }catch (error) {
      throw AppException("فشل في تحميل أفلام قادمة. تأكد من الاتصال بالإنترنت.");
    }

  }

  @override
  Future<void> cachePopularMovies(List<MovieModel> movies) async {
    final box = await _box;
    await box.clear();
    for (var movie in movies) {
      await box.put(movie.id, movie);
    }
  }

  @override
  Future<List<MovieModel>> getCachedPopularMovies() async {
    final box = await _box;
    return box.values.toList();
  }

  @override
  Future<void> clearCachedPopularMovies() async {
    final box = await _box;
    await box.clear();
  }
}

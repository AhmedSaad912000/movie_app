
import '../../../local_provider/movie_hive_model.dart';

abstract class PopularMoviesRepo {
  Future<List<MovieModel>> fetchPopularMovies({int page = 1});

  Future<void> cachePopularMovies(List<MovieModel> movies);

  Future<List<MovieModel>> getCachedPopularMovies();

  Future<void> clearCachedPopularMovies();
}

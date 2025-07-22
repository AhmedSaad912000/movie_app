
import '../../../local_provider/movie_hive_model.dart';

abstract class TopRatedMoviesRepo {
  Future<List<MovieModel>> fetchTopRatedMovies({int page = 1});
  Future<void> cacheTopRatedMovies(List<MovieModel> movies);
  Future<List<MovieModel>> getCachedTopRatedMovies();
  Future<void> clearCachedTopRatedMovies();
}

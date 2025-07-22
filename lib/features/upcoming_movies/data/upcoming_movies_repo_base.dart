
import '../../../local_provider/movie_hive_model.dart';

abstract class UpcomingMoviesRepo {
  Future<List<MovieModel>> fetchUpcomingMovies( {int page = 1});

  Future<void> cacheUpcomingMovies(List<MovieModel> movies);

  Future<List<MovieModel>> getCachedUpcomingMovies();

  Future<void> clearCachedUpcomingMovies();
}

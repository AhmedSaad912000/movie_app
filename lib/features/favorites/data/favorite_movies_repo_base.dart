import '../../../local_provider/movie_hive_model.dart';

abstract class FavoriteMoviesRepositoryBase {
  Future<void> toggleFavorite(MovieModel movie);
  Future<bool> isFavorite(int movieId);
  Future<List<MovieModel>> getFavoriteMovies();
}

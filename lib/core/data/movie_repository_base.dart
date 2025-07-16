import '../../models/details_movie_model.dart';
import '../../models/movie_hive_model.dart';
import '../../models/show_favorite_movies_model.dart';
import 'movie_repository.dart';
abstract class MovieRepositoryBase {
  Future<List<MovieModel>> fetchMovies(MovieType type, {int page});
  Future<List<MovieModel>> filterByGenre({required int genreId, required MovieType type});
  Future<DetailsMovieData> getMovieDetailsFromApi(int id);
  Future<List<MovieModel>> getSimilarMovies(int movieId);
  Future<void> toggleFavorite(MovieModel movie);
  Future<bool> isFavorite(int movieId);
  Future<List<MovieModel>> getFavoriteMovies();
  Future<bool> markFavorite({required int movieId, required bool isFavorite});
  Future<List<ShowFavoriteMovieModel>> getFavoriteMoviesFromApi();
}

import '../../../local_provider/movie_hive_model.dart';
import '../models/details_movie_model.dart';

abstract class MovieDetailsRepo {
  Future<DetailsMovieData> fetchMovieDetails(int movieId);
  Future<List<MovieModel>> fetchSimilarMovies(int movieId);

}

import 'package:movie_app/local_provider/movie_hive_model.dart';

import '../../favorites/models/show_favorite_movies_model.dart';

abstract class AddFavoriteMoviesRepositoryBase {
  Future<bool> markFavorite({
    required int movieId,
    required bool isFavorite,
  });
  Future<List<MovieModel>> getFavoriteMoviesFromApi();
}

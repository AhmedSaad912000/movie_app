import '../model/genres_model.dart';

abstract class GenresRepo {
  Future<List<GenreMoviesData>> fetchGenres();
}

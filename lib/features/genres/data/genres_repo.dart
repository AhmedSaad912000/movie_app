import 'package:movie_app/core/data/dio_helper.dart';
import 'package:movie_app/core/widgets/app_exception.dart';
import '../model/genres_model.dart';
import 'genres_repo_base.dart';

class GenresRepoImpl implements GenresRepo {
  @override
  Future<List<GenreMoviesData>> fetchGenres() async {
    final response = await DioHelper.get('genre/movie/list');

    if (response.isSuccess) {
      final genresList = response.data['genres'] as List;
      return genresList.map((json) => GenreMoviesData.fromJson(json)).toList();
    } else {
      throw AppException(message: response.msg);
    }
  }
}

import 'package:movie_app/core/data/dio_helper.dart';
import 'package:movie_app/core/widgets/app_exception.dart';
import '../model/genres_model.dart';
import 'genres_repo_base.dart';

class GenresRepoImpl implements GenresRepo {
  @override
  Future<List<GenreMoviesData>> fetchGenres() async {
    try {
      final response = await DioHelper.get('genre/movie/list');

      if (response.isSuccess) {
        final genresList = response.data['genres'];
        if (genresList is List) {
          return genresList.map((json) => GenreMoviesData.fromJson(json)).toList();
        } else {
          throw AppException("صيغة البيانات غير متوقعة من الخادم.");
        }
      } else {
        throw AppException(response.msg);
      }
    } catch (e) {
      throw AppException("فشل تحميل الأنواع. تحقق من الاتصال بالإنترنت.");
    }
  }
}

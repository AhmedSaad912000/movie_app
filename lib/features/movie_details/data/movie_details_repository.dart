import 'package:movie_app/core/data/dio_helper.dart';
import 'package:movie_app/core/widgets/app_exception.dart';
import 'package:movie_app/features/movie_details/models/details_movie_model.dart';
import '../models/similar_movie_model.dart';

import '../../../local_provider/movie_hive_model.dart';
import 'movie_details_repo_base.dart';

class MovieDetailsRepository implements MovieDetailsRepo {
  @override
  Future<DetailsMovieData> fetchMovieDetails(int movieId) async {
    final response = await DioHelper.get('movie/$movieId');

    if (response.isSuccess) {
      return DetailsMovieData.fromJson(response.data);
    } else {
      throw AppException( response.msg);
    }
  }

  @override
  @override
  Future<List<MovieModel>> fetchSimilarMovies(int movieId) async {
    try {
      final response = await DioHelper.get('movie/$movieId/similar');

      if (response.isSuccess) {
        final results = response.data['results'];
        if (results is List) {
          return results.map((e) => SimilarMovieModel.fromJson(e)).toList();
        } else {
          throw AppException("لم يتم العثور على أفلام مشابهة.");
        }
      } else {
        throw AppException(response.msg);
      }
    } catch (e) {
      throw AppException("حدث خطأ أثناء تحميل الأفلام المشابهة.");
    }
  }
}

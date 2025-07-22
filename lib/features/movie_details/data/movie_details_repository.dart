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
      throw AppException(message: response.msg);
    }
  }

  @override
  Future<List<MovieModel>> fetchSimilarMovies(int movieId) async {
    final response = await DioHelper.get('movie/$movieId/similar');

    if (response.isSuccess) {
      return (response.data['results'] as List)
          .map((e) => SimilarMovieModel.fromJson(e))
          .toList();
    } else {
      throw AppException(message: response.msg);
    }
  }
}

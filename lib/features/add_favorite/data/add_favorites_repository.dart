import 'package:hive/hive.dart';
import 'package:movie_app/features/favorites/models/show_favorite_movies_model.dart';
import '../../../core/data/dio_helper.dart';
import '../../../core/widgets/app_exception.dart';
import '../../../local_provider/movie_hive_model.dart';
import 'add_favorite_movies_repo_base.dart';

class AddFavoriteRepository implements AddFavoriteMoviesRepositoryBase {
  final int accountId = 22093634;
  final String _boxName = 'favoritesBox';

  @override
  Future<bool> markFavorite({
    required int movieId,
    required bool isFavorite,
  }) async {
    final response = await DioHelper.post(
      'account/$accountId/favorite',
      data: {
        'media_type': 'movie',
        'media_id': movieId,
        'favorite': isFavorite,
      },
    );

    if (response.isSuccess) {
      return true;
    } else {
      throw AppException(response.msg);
    }
  }

  @override
  Future<List<MovieModel>> getFavoriteMoviesFromApi() async {
    final box = await Hive.openBox<MovieModel>(_boxName);

    if (box.isNotEmpty) {
      return box.values.toList();
    }

    final response = await DioHelper.get('account/$accountId/favorite/movies');

    final results = response.data['results'] as List;

    final movies = results.map((e) => MovieModel.fromJson(e)).toList();

    for (var movie in movies) {
      await box.put(movie.id, movie);
    }

    return movies;
  }


  }



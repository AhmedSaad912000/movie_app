import 'package:hive/hive.dart';
import 'package:movie_app/features/favorites/models/show_favorite_movies_model.dart';
import 'package:movie_app/local_provider/movie_hive_model.dart';
import '../../../core/data/dio_helper.dart';
import '../../../core/widgets/app_exception.dart';
import 'favorite_movies_repo_base.dart';

class FavoriteMoviesRepository implements FavoriteMoviesRepositoryBase {
  final String _boxName = 'favoritesBox';

  @override
  Future<void> toggleFavorite(MovieModel movie) async {
    final box = await Hive.openBox<MovieModel>(_boxName);
    try{
      if (box.containsKey(movie.id)) {
        await box.delete(movie.id);
        print('🗑 Removed from favorites');
      } else {
        await box.put(movie.id, movie);
        print('❤️ Added to favorites');
      }
    } catch (e) {
      throw AppException("فشل تحديث المفضلة. حاول لاحقًا.");
    }
  }

  @override
  Future<bool> isFavorite(int movieId) async {
    final box = await Hive.openBox<MovieModel>(_boxName);
    return box.containsKey(movieId);
  }

  @override
  Future<List<MovieModel>> getFavoriteMovies() async {
    try {
      final box = await Hive.openBox<MovieModel>(_boxName);
      if (box.isNotEmpty) {
        return box.values.toList();
      }
      final response = await DioHelper.get('account/22093634/favorite/movies');
      if (response.isSuccess) {
        final results = response.data['results'] as List;

        final movies = results.map((e) => MovieModel.fromJson(e)).toList();

        for (var movie in movies) {
          await box.put(movie.id, movie);
        }
        return movies;
      } else {
        throw AppException("بيانات الأفلام المفضلة غير صحيحة.");
      }
    } catch (e) {
      throw AppException("فشل تحميل الأفلام المفضلة. تحقق من اتصالك بالإنترنت.");
    }




  }
}

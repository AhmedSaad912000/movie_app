import 'package:hive/hive.dart';
import 'movie_hive_model.dart';
part 'movie_list_cache_model.g.dart';
@HiveType(typeId: 1)
class MovieListCacheModel extends HiveObject {
  @HiveField(0)
  final List<MovieModel> movies;

  @HiveField(1)
  final DateTime cachedAt;

  MovieListCacheModel({
    required this.movies,
    required this.cachedAt,
  });
}

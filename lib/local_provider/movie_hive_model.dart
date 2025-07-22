import 'package:hive/hive.dart';

import '../features/movie_details/models/details_movie_model.dart';
part 'movie_hive_model.g.dart';
@HiveType(typeId: 0)
class MovieModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String posterPath;

  @HiveField(3)
  final String overview;

  @HiveField(4)
  final String backdropPath;

  @HiveField(5)
  final List<int> genreIds;

  MovieModel({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.backdropPath,
    required this.genreIds,
  });
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
    return MovieModel(
      id: json['id'],
      title: json['title'] ?? '',
      posterPath: json['poster_path'] != null
          ? '$imageBaseUrl${json['poster_path']}'
          : '',
      overview: json['overview'] ?? '',
      backdropPath: json['backdrop_path'] != null
          ? '$imageBaseUrl${json['backdrop_path']}'
          : '',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
    );
  }
  factory MovieModel.fromDetails(DetailsMovieData details) {
    return MovieModel(
      id: details.id,
      title: details.title,
      posterPath: details.posterPath,
      overview: details.overview,
      backdropPath: details.backdropPath,
      genreIds: details.genres.map((genre) => genre.id).toList(),
    );
  }

}

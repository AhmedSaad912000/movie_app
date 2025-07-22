import 'dart:convert';

import '../../../local_provider/movie_hive_model.dart';
class PopularMoviesData {
  late final int page;
  late final List<MoviePopularModel> list;
  late final int totalPages;
  late final int totalResults;

  PopularMoviesData.fromJson(Map<String, dynamic> json){
    page = json['page'];
    list = List.from(json['results']).map((e)=>MoviePopularModel.fromJson(e)).toList();
    totalPages = json['total_pages'];
    totalResults = json['total_results'];
  }
}


class MoviePopularModel extends MovieModel {
  final bool adult;
  final List<int> genreIds;
  final String originalLanguage;
  final String originalTitle;
  final String releaseDate;
  final bool video;
  final double? voteAverage;
  final int voteCount;
  final double popularity;

  MoviePopularModel({
    required this.adult,
    required this.genreIds,
    required this.originalLanguage,
    required this.originalTitle,
    required this.releaseDate,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
    required this.popularity,

    /// لازم تبعت القيم للـ MovieModel الأب
    required int id,
    required String title,
    required String posterPath,
    required String overview,
    required String backdropPath,
  }) : super(
    id: id,
    title: title,
    posterPath: posterPath,
    overview: overview,
    backdropPath: backdropPath,
    genreIds: genreIds,

  );

  factory MoviePopularModel.fromJson(Map<String, dynamic> json) {
    return MoviePopularModel(
      id: json['id'],
      title: json['title'] ?? '',
      posterPath: "https://image.tmdb.org/t/p/w500${json['poster_path'] ?? ''}",
      overview: json['overview'] ?? '',
      backdropPath: "https://image.tmdb.org/t/p/w500${json['backdrop_path'] ?? ''}",
      adult: json['adult'] ?? false,
      genreIds: List.castFrom<dynamic, int>(json['genre_ids']),
      originalLanguage: json['original_language'] ?? '',
      originalTitle: json['original_title'] ?? '',
      popularity: (json['popularity'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? '',
      video: json['video'] ?? false,
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
    );
  }
}

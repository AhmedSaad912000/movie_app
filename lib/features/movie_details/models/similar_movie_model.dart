import '../../../local_provider/movie_hive_model.dart';
class SimilarMovieData {
  late final int page;
  late final List<SimilarMovieModel> list;
  late final int totalPages;
  late final int totalResults;

  SimilarMovieData.fromJson(Map<String, dynamic> json){
    page = json['page'];
    list = List.from(json['results']).map((e)=>SimilarMovieModel.fromJson(e)).toList();
    totalPages = json['total_pages'];
    totalResults = json['total_results'];
  }

}


class SimilarMovieModel extends MovieModel {
  final bool adult;
  final String originalLanguage;
  final String originalTitle;
  final double popularity;
  final String releaseDate;
  final bool video;
  final double? voteAverage;
  final int voteCount;

  SimilarMovieModel({
    required this.adult,
    required this.originalLanguage,
    required this.originalTitle,
    required this.popularity,
    required this.releaseDate,
    required this.video,
    required this.voteAverage,
    required this.voteCount,

    // ✅ تمرير القيم للأب
    required int id,
    required String title,
    required String posterPath,
    required String overview,
    required String backdropPath,
    required List<int> genreIds,
  }) : super(
    id: id,
    title: title,
    posterPath: posterPath,
    overview: overview,
    backdropPath: backdropPath,
    genreIds: genreIds,
  );

  factory SimilarMovieModel.fromJson(Map<String, dynamic> json) {
    return SimilarMovieModel(
      id: json['id'],
      title: json['title'],
      posterPath: "https://image.tmdb.org/t/p/w500${json['poster_path'] ?? ''}",
      overview: json['overview'],
      backdropPath: "https://image.tmdb.org/t/p/w500${json['backdrop_path'] ?? ''}",
      genreIds: List<int>.from(json['genre_ids']),
      adult: json['adult'],
      originalLanguage: json['original_language'],
      originalTitle: json['original_title'],
      popularity: (json['popularity'] ?? 0).toDouble(),
      releaseDate: json['release_date'],
      video: json['video'],
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'],
    );
  }
}

import '../../../local_provider/movie_hive_model.dart';

class ShowFavoriteMoviesData {
  late final int page;
  late final List<ShowFavoriteMovieModel> list;
  late final int totalPages;
  late final int totalResults;

  ShowFavoriteMoviesData.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    list = List.from(json['results'])
        .map((e) => ShowFavoriteMovieModel.fromJson(e))
        .toList();
    totalPages = json['total_pages'];
    totalResults = json['total_results'];
  }
}

class ShowFavoriteMovieModel extends MovieModel {
  final bool adult;
  final List<int> genreIds;
  final String originalLanguage;
  final String originalTitle;
  final String releaseDate;
  final bool video;
  final double? voteAverage;
  final int voteCount;
  final double popularity;

  ShowFavoriteMovieModel({
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

  factory ShowFavoriteMovieModel.fromJson(Map<String, dynamic> json) {
    return ShowFavoriteMovieModel(
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
  factory ShowFavoriteMovieModel.fromMovieModel(MovieModel movie) {
    return ShowFavoriteMovieModel(
      id: movie.id,
      title: movie.title,
      posterPath: movie.posterPath,
      overview: movie.overview,
      backdropPath: movie.backdropPath,
      genreIds: movie.genreIds,
      adult: false, // قيم افتراضية أو حسب الحاجة
      originalLanguage: '',
      originalTitle: '',
      popularity: 0,
      releaseDate: '',
      video: false,          // بدل null هنا
      voteAverage: null,
      voteCount: 0,
    );
  }

}

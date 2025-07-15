import 'movie_hive_model.dart';
class TopRatedMoviesData {
  late final int page;
  late final List<TopRatedMovieModel> list;
  late final int totalPages;
  late final int totalResults;
  TopRatedMoviesData.fromJson(Map<String, dynamic> json){
    page = json['page'];
    list = List.from(json['results']).map((e)=>TopRatedMovieModel.fromJson(e)).toList();
    totalPages = json['total_pages'];
    totalResults = json['total_results'];
  }


}


class TopRatedMovieModel extends MovieModel {
  final double? voteAverage;

  TopRatedMovieModel({
    required this.voteAverage,
    required int id,
    required String title,
    required String posterPath,
    required String overview,
    required String backdropPath,
    required List<int> genreIds, // ✅ أضف دي
  }) : super(
    id: id,
    title: title,
    posterPath: posterPath,
    overview: overview,
    backdropPath: backdropPath,
    genreIds: genreIds, // ✅ مررها لـ super

  );

  factory TopRatedMovieModel.fromJson(Map<String, dynamic> json) {
    return TopRatedMovieModel(
      id: json['id'],
      title: json['title'] ?? '',
      posterPath: "https://image.tmdb.org/t/p/w500${json['poster_path'] ?? ''}",
      overview: json['overview'] ?? '',
      backdropPath: "https://image.tmdb.org/t/p/w500${json['backdrop_path'] ?? ''}",
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      genreIds: List<int>.from(json['genre_ids'] ?? []), // ✅ هنا نقرأهم من JSON
    );
  }
}

import '../../../local_provider/movie_hive_model.dart';
class UpcomingMovieData {
  late final Dates  dates;
  late final int page;
  late final List<MovieUpComingModel> list;
  late final int totalPages;
  late final int totalResults;

  UpcomingMovieData.fromJson(Map<String, dynamic> json){


    page = json['page'];
    list = List.from(json['results']).map((e)=>MovieUpComingModel.fromJson(e)).toList();
    totalPages = json['total_pages'];
    totalResults = json['total_results'];
  }
}

class Dates {
  late final String maximum;
  late final String minimum;

  Dates.fromJson(Map<String, dynamic> json){
    maximum = json['maximum'];
    minimum = json['minimum'];
  }

}



class MovieUpComingModel extends MovieModel {
  final String releaseDate;
  MovieUpComingModel({
    required this.releaseDate,
    required int id,
    required String title,
    required String posterPath,
    required String overview,
    required String backdropPath,
    required List<int> genreIds, // ✅ هنا أضفناها
  }) : super(
    id: id,
    title: title,
    posterPath: posterPath,
    overview: overview,
    backdropPath: backdropPath,
    genreIds: genreIds,
  );

  factory MovieUpComingModel.fromJson(Map<String, dynamic> json) {
    return MovieUpComingModel(
      id: json['id'],
      title: json['title'] ?? '',
      posterPath: "https://image.tmdb.org/t/p/w500${json['poster_path'] ?? ''}",
      overview: json['overview'] ?? '',
      backdropPath: "https://image.tmdb.org/t/p/w500${json['backdrop_path'] ?? ''}",
      releaseDate: json['release_date'] ?? '',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
    );
  }
}

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

class MovieUpComingModel {
  late final bool adult;
  late final String backdropPath;
  late final List<int> genreIds;
  late final int id;
  late final String originalLanguage;
  late final String originalTitle;
  late final String overview;
  late final double popularity;
  late final String posterPath;
  late final String releaseDate;
  late final String title;
  late final bool video;
  late final double? voteAverage;
  late final int voteCount;

  MovieUpComingModel.fromJson(Map<String, dynamic> json){
    adult = json['adult'];
    backdropPath ="https://image.tmdb.org/t/p/w500 ${json['backdrop_path']}";
    genreIds = List.castFrom<dynamic, int>(json['genre_ids']);
    id = json['id'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    overview = json['overview'];
    popularity = json['popularity'];
    posterPath = "https://image.tmdb.org/t/p/w500${json['poster_path']}";
    releaseDate = json['release_date'];
    title = json['title'];
    video = json['video'];
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
  }
}
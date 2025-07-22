class GenreMoviesData {
  late final List<MovieGenresModel> list;
  GenreMoviesData.fromJson(Map<String, dynamic> json){
    list = List.from(json['genres']).map((e)=>MovieGenresModel.fromJson(e)).toList();
  }
}

class MovieGenresModel {
  late final int id;
  late final String name;

  MovieGenresModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
  }


}
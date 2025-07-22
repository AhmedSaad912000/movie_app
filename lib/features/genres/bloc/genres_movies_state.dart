part of 'genres_movies_bloc.dart';

abstract class GenresStates {}

class GenresInitialState extends GenresStates {}

class GenresLoadingState extends GenresStates {}

class GenresSuccessState extends GenresStates {
  final List<MovieGenresModel> list;
  GenresSuccessState({ required this.list});
}

class GenresErrorState extends GenresStates {
  final String msg;
  GenresErrorState({required this.msg});
}
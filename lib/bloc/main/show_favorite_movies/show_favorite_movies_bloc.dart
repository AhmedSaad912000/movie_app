import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/error/app_exception.dart';
import 'package:movie_app/models/show_favorite_movies_model.dart';

import '../../../core/data/movie_repository.dart';
import '../../../core/data/movie_repository_base.dart';

part 'show_favorite_movies_event.dart';
part 'show_favorite_movies_state.dart';
class ShowFavoriteMoviesBloc extends Bloc<ShowFavoriteMoviesEvents, ShowFavoriteMoviesStates> {
  final MovieRepositoryBase movieRepository;
  List<ShowFavoriteMovieModel> _allFavorites = [];
  ShowFavoriteMoviesBloc({required this.movieRepository}) : super(ShowFavoriteMoviesStates()) {
    on<ShowFavoriteMoviesEvent>(_getFavoriteMovies);
    on<FilterShowFavoriteMoviesByGenreEvent>(_filterShowFavoriteByGenre);
  }

  Future<void> _getFavoriteMovies(ShowFavoriteMoviesEvent event, Emitter<ShowFavoriteMoviesStates> emit) async {
    try {
      final list = await movieRepository.getFavoriteMoviesFromApi();
      _allFavorites = list;
      emit(ShowFavoriteMoviesSuccessState(list: list));
    } on AppException catch (e) {
      emit(ShowFavoriteMoviesFailedState(msg: e.message));
    } catch (ex) {
      emit(ShowFavoriteMoviesFailedState(msg: ex.toString()));
    }
  }

  Future<void> _filterShowFavoriteByGenre(FilterShowFavoriteMoviesByGenreEvent event, Emitter<ShowFavoriteMoviesStates> emit) async {
    try {
      final filteredList = _allFavorites.where((movie) {
        return movie.genreIds.contains(event.genreId);
      }).toList();
      emit(ShowFavoriteMoviesSuccessState(list: filteredList));
    } catch (ex) {
      emit(ShowFavoriteMoviesFailedState(msg: "خطأ أثناء الفلترة: ${ex.toString()}"));
    }
  }
}

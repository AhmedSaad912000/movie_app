import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/local_provider/movie_hive_model.dart';

import '../data/top_rated_movies_repo_base.dart';
part 'top_rated_movies_event.dart';
part 'top_rated_movies_state.dart';

class TopRatedMovieBloc extends Bloc<TopRatedEvents, TopRatedStates> {
  final TopRatedMoviesRepo repository;
  int page = 1;
  final int limit = 20;
   bool isFetching = false;

  TopRatedMovieBloc({required this.repository}) : super(TopRatedStates()) {
    on<RefreshRatedEvent>(_refreshTopRatedMovies);
    on<TopRatedEvent>(_getTopRatedMovies);
    on<FilterTopRatedMoviesByGenreEvent>(_filterTopRatedByGenre);
  }

  Future<void> _refreshTopRatedMovies(RefreshRatedEvent event, Emitter<TopRatedStates> emit) async {
    page = 1;
     isFetching = true;
    try {
      final movies = await repository.fetchTopRatedMovies(page: page);
      page++;
      emit(TopRatedSuccessState(list: movies, hasReachedMax: movies.length < limit));
    } catch (ex) {
      emit(TopRatedFailedState(msg: ex.toString()));
    }
     isFetching = false;
  }

  Future<void> _getTopRatedMovies(TopRatedEvent event, Emitter<TopRatedStates> emit) async {
     if (isFetching) return;
     isFetching = true;
    try {
      final movies = await repository.fetchTopRatedMovies(page: page);
      page++;
      final currentState = state;
      if (currentState is TopRatedSuccessState) {
        final updatedList = List<MovieModel>.from(currentState.list)..addAll(movies);
        emit(TopRatedSuccessState(list: updatedList, hasReachedMax: movies.length < limit));
      } else {
        emit(TopRatedSuccessState(list: movies, hasReachedMax: movies.length < limit));
      }
    } catch (ex) {
      emit(TopRatedFailedState(msg: ex.toString()));
    }
     isFetching = false;
  }

  Future<void> _filterTopRatedByGenre(FilterTopRatedMoviesByGenreEvent event, Emitter<TopRatedStates> emit) async {
    try {
      final allMovies = await repository.fetchTopRatedMovies();
      final filteredList = allMovies.where((movie) => movie.genreIds.contains(event.genreId)).toList();
      emit(TopRatedSuccessState(list: filteredList, hasReachedMax: true));
    } catch (ex) {
      emit(TopRatedFailedState(msg: "فشل في فلترة الأفلام: ${ex.toString()}"));
    }
  }
}

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/models/movie_hive_model.dart';
import '../../../core/data/movie_repository.dart';
import '../../../core/data/movie_repository_base.dart';
part 'upcoming_movies_event.dart';
part 'upcoming_movies_state.dart';
class UpcomingMovieBloc extends Bloc<UpComingEvents, UpComingStates> {
  final MovieRepositoryBase repository;
  int page = 1;
  final int limit = 20;
  bool isFetching = false;
  UpcomingMovieBloc({required this.repository}) : super(UpComingStates()) {
    on<RefreshUpcomingEvent>(_refreshUpComingMovies);
    on<UpComingEvent>(_getUpComingMovies);
    on<FilterUpcomingMoviesByGenreEvent>(_filterUpComingByGenre);
  }

  Future<void> _refreshUpComingMovies(RefreshUpcomingEvent event, Emitter<UpComingStates> emit) async {
    page = 1;
    isFetching = true;
    try {
      final movies = await repository.fetchMovies(MovieType.upcoming, page: page); // ✅ صحح النوع
      page++;
      emit(UpComingSuccessState(list: movies, hasReachedMax: movies.length < limit));
    } catch (ex) {
      emit(UpComingErrorState(msg: ex.toString()));
    }
    isFetching = false;
  }

  Future<void> _getUpComingMovies(UpComingEvent event, Emitter<UpComingStates> emit) async {
    if (isFetching) return;
    isFetching = true;
    try {
      final movies = await repository.fetchMovies(MovieType.upcoming, page: page); // ✅ صحح النوع
      page++;
      final currentState = state;
      if (currentState is UpComingSuccessState) {
        final updatedList = List<MovieModel>.from(currentState.list)..addAll(movies);
        emit(UpComingSuccessState(list: updatedList, hasReachedMax: movies.length < limit));
      } else {
        emit(UpComingSuccessState(list: movies, hasReachedMax: movies.length < limit));
      }
    } catch (ex) {
      emit(UpComingErrorState(msg: ex.toString()));
    }
    isFetching = false;
  }

  Future<void> _filterUpComingByGenre(FilterUpcomingMoviesByGenreEvent event, Emitter<UpComingStates> emit) async {
    try {
      final allMovies = await repository.fetchMovies(MovieType.upcoming);
      final filteredList = allMovies.where((movie) => movie.genreIds.contains(event.genreId)).toList();
      emit(UpComingSuccessState(list: filteredList, hasReachedMax: true));
    } catch (ex) {
      emit(UpComingErrorState(msg: "فشل في فلترة الأفلام: ${ex.toString()}"));
    }
  }
}

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/models/movie_hive_model.dart';
import '../../../core/data/movie_repository.dart';
import '../../../core/data/movie_repository_base.dart';
import '../../../models/popular_movies_model.dart';
part 'popular_movies_event.dart';
part 'popular_movies_state.dart';

class PoplarMoviesBloc extends Bloc<PopularMovieEvents, PopularMoviesStates> {
  PoplarMoviesBloc() : super(PopularMoviesStates()) {
    final MovieRepositoryBase repo = MovieRepositoryImpl();
    on<GetPopularMovieEvent>((event, emit) async {
      emit(PopularLoadingState());
      try {
        final movies = await repo.fetchMovies(MovieType.popular);
        emit(PopularSuccessState(list: movies.cast<MovieModel>()));
      } catch (e) {
        emit(PopularFailedState(msg: e.toString()));
      }
    });

  }





  }


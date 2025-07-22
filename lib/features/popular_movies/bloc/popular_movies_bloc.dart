import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/popular_movies/data/popular_movies_repository.dart';
import 'package:movie_app/local_provider/movie_hive_model.dart';

import '../data/popular_movies_repo_base.dart';
import '../models/popular_movies_model.dart';
part 'popular_movies_event.dart';
part 'popular_movies_state.dart';

class PoplarMoviesBloc extends Bloc<PopularMovieEvents, PopularMoviesStates> {
  final PopularMoviesRepo repository;
  PoplarMoviesBloc({required  this.repository}) : super(PopularMoviesStates()) {
    on<GetPopularMovieEvent>((event, emit) async {
      emit(PopularLoadingState());
      try {
        final movies = await repository.fetchPopularMovies();
        emit(PopularSuccessState(list: movies.cast<MovieModel>()));
      } catch (e) {
        emit(PopularFailedState(msg: e.toString()));
      }
    });

  }





  }


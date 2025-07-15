import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/error/app_exception.dart';
import 'package:movie_app/models/movie_hive_model.dart';
import 'package:movie_app/models/similar_movie_model.dart';

import '../../../core/data/movie_repository.dart';
import '../../../core/data/movie_repository_base.dart';

part 'similar_movie_event.dart';
part 'similar_movie_state.dart';

class SimilarMovieBloc extends Bloc<SimilarMovieEvents, SimilarMovieStates> {
  final MovieRepositoryBase movieRepository;

  SimilarMovieBloc({required this.movieRepository}) : super(SimilarMovieStates()) {
    on<SimilarMovieEvent>(_getSimilarMovie);
  }

  Future<void> _getSimilarMovie(SimilarMovieEvent event, Emitter<SimilarMovieStates> emit) async {
    try {
      final list = await movieRepository.getSimilarMovies(event.id);
      emit(SimilarMovieSuccessState(list: list));
    } on AppException catch (e) {
      emit(SimilarMovieFailedState(msg: e.message));
    } catch (ex) {
      emit(SimilarMovieFailedState(msg: ex.toString()));
    }
  }
}

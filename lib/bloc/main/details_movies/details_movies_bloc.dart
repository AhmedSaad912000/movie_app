import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/error/app_exception.dart';
import 'package:movie_app/models/details_movie_model.dart';

import '../../../core/data/movie_repository.dart';
import '../../../core/data/movie_repository_base.dart';

part 'details_movies_event.dart';
part 'details_movies_state.dart';

class DetailsMoviesBloc extends Bloc<DetailsMoviesEvents, DetailsMoviesStates> {
  final MovieRepositoryBase  movieRepository;

  DetailsMoviesBloc({required this.movieRepository}) : super(DetailsMoviesStates()) {
    on<GetDetailsMovieEvent>(_getData);
  }

  Future<void> _getData(GetDetailsMovieEvent event, Emitter<DetailsMoviesStates> emit) async {
    emit(DetailsMovieStateLoading());
    try {
      final model = await movieRepository.getMovieDetailsFromApi(event.id);
      emit(DetailsMovieStateSuccess(model: model));
    } on AppException catch (e) {
      emit(DetailsMovieStateFailed(msg: e.message));
    } catch (ex) {
      emit(DetailsMovieStateFailed(msg: ex.toString()));
    }
  }
}

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/widgets/app_exception.dart';
import 'package:movie_app/features/movie_details/models/details_movie_model.dart';


import '../data/movie_details_repo_base.dart';

part 'details_movies_event.dart';
part 'details_movies_state.dart';

class DetailsMoviesBloc extends Bloc<DetailsMoviesEvents, DetailsMoviesStates> {
  final MovieDetailsRepo  movieRepository;

  DetailsMoviesBloc({required this.movieRepository}) : super(DetailsMoviesStates()) {
    on<GetDetailsMovieEvent>(_getData);
  }

  Future<void> _getData(GetDetailsMovieEvent event, Emitter<DetailsMoviesStates> emit) async {
    emit(DetailsMovieStateLoading());
    try {
      final model = await movieRepository.fetchMovieDetails(event.id);
      emit(DetailsMovieStateSuccess(model: model));
    } on AppException catch (e) {
      emit(DetailsMovieStateFailed(msg: e.message));
    } catch (ex) {
      emit(DetailsMovieStateFailed(msg: ex.toString()));
    }
  }
}

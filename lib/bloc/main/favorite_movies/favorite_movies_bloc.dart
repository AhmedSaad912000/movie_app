import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/error/app_exception.dart';

import '../../../core/data/movie_repository.dart';
import '../../../core/data/movie_repository_base.dart';

part 'favorite_movies_event.dart';
part 'favorite_movies_state.dart';

class AddFavoriteMoviesBloc extends Bloc<AddFavoriteMoviesEvents, AddFavoriteMoviesStates> {
  final MovieRepositoryBase movieRepository;

  AddFavoriteMoviesBloc({required this.movieRepository}) : super(AddFavoriteMoviesInitState()) {
    on<AddFavoriteEvent>(_addToFavorite);
  }

  Future<void> _addToFavorite(AddFavoriteEvent event, Emitter<AddFavoriteMoviesStates> emit) async {
    try {
      final success = await movieRepository.markFavorite(
        movieId: event.id,
        isFavorite: event.isFavs,
      );

      if (success) {
        emit(AddFavoriteMoviesSuccessState(isFavs: event.isFavs));
      } else {
        emit(AddFavoriteMoviesFailedState(msg: "حدث خطأ أثناء التغيير"));
      }
    } on AppException catch (e) {
      emit(AddFavoriteMoviesFailedState(msg: e.message));
    } catch (ex) {
      emit(AddFavoriteMoviesFailedState(msg: ex.toString()));
    }
  }
}

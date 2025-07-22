import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:kiwi/kiwi.dart';
import 'package:movie_app/core/widgets/app_exception.dart';

import '../../../local_provider/movie_hive_model.dart';
import '../../favorites/bloc/show_favorite_movies_bloc.dart';
import '../../movie_details/data/movie_details_repo_base.dart';
import '../data/add_favorite_movies_repo_base.dart';
part 'favorite_movies_event.dart';
part 'favorite_movies_state.dart';

class AddFavoriteMoviesBloc extends Bloc<AddFavoriteMoviesEvents, AddFavoriteMoviesStates> {
  final AddFavoriteMoviesRepositoryBase movieRepository;
  final MovieDetailsRepo movieDetailsRepo;


  AddFavoriteMoviesBloc({
    required this.movieRepository,
    required this.movieDetailsRepo,
  }) : super(AddFavoriteMoviesInitState()) {
    on<AddFavoriteEvent>(_addToFavorite);
  }


  Future<void> _addToFavorite(AddFavoriteEvent event, Emitter<AddFavoriteMoviesStates> emit) async {
    try {
      emit(AddFavoriteMoviesLoadingState());
      final result = await movieRepository.markFavorite(
        movieId: event.id,
        isFavorite: event.isFavs,
      );
      if (result) {
        final box = await Hive.openBox<MovieModel>('favoritesBox');

        if (event.isFavs) {
          final details = await movieDetailsRepo.fetchMovieDetails(event.id);
          final movie = MovieModel.fromDetails(details);
          await box.put(event.id, movie);

        } else {
          // لو بيحذف من المفضلة
          await box.delete(event.id);
        }
        emit(AddFavoriteMoviesSuccessState(isFavs: event.isFavs));
        KiwiContainer().resolve<ShowFavoriteMoviesBloc>().add(ShowFavoriteMoviesEvent());

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

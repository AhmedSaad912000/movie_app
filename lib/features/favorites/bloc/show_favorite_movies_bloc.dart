import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/local_provider/movie_hive_model.dart';


import '../../../core/widgets/app_exception.dart';
import '../data/favorite_movies_repo_base.dart';
import '../models/show_favorite_movies_model.dart';

part 'show_favorite_movies_event.dart';
part 'show_favorite_movies_state.dart';
class ShowFavoriteMoviesBloc extends Bloc<ShowFavoriteMoviesEvents, ShowFavoriteMoviesStates> {
  final FavoriteMoviesRepositoryBase movieRepository;
  List<ShowFavoriteMovieModel> _allFavorites = [];
  ShowFavoriteMoviesBloc({required this.movieRepository}) : super(ShowFavoriteMoviesStates()) {
    on<ShowFavoriteMoviesEvent>(_getFavoriteMovies);
    on<FilterShowFavoriteMoviesByGenreEvent>(_filterShowFavoriteByGenre);
  }

  Future<void> _getFavoriteMovies(ShowFavoriteMoviesEvent event, Emitter<ShowFavoriteMoviesStates> emit) async {
    emit(ShowFavoriteMoviesLoadingState());
    try {
      final movies = await movieRepository.getFavoriteMovies();
      final List<ShowFavoriteMovieModel> favoritesList = movies.map((movie) => ShowFavoriteMovieModel.fromMovieModel(movie)).toList();

      _allFavorites = favoritesList;
      emit(ShowFavoriteMoviesSuccessState(list: favoritesList));
    } on AppException catch (e) {
      emit(ShowFavoriteMoviesFailedState(msg: e.message));
    } catch (ex) {
      emit(ShowFavoriteMoviesFailedState(msg: "حدث خطأ غير متوقع أثناء جلب الأفلام المفضلة."));
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
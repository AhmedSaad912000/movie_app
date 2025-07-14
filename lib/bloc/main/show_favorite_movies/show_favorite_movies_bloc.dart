import 'dart:async';


import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/util/dio_helper.dart';
import '../../../models/show_favorite_movies_model.dart';

part 'show_favorite_movies_event.dart';

part 'show_favorite_movies_state.dart';

class ShowFavoriteMoviesBloc extends Bloc<ShowFavoriteMoviesEvents, ShowFavoriteMoviesStates> {
  List<ShowFavoriteMovieModel> _allFavorites = [];
  ShowFavoriteMoviesBloc() : super(ShowFavoriteMoviesStates()) {
    on<ShowFavoriteMoviesEvent>(_getFavoriteMovies);
    on<FilterShowFavoriteMoviesByGenreEvent>(_filterShowFavoriteByGenre);
  }

  Future<void> _getFavoriteMovies(ShowFavoriteMoviesEvent event,
      Emitter<ShowFavoriteMoviesStates> emit) async {
    try {
      final response = await DioHelper.get('account/22093634/favorite/movies');
      if (response.isSuccess) {
        final model = ShowFavoriteMoviesData.fromJson(response.data);
        _allFavorites = model.list;
        emit(ShowFavoriteMoviesSuccessState(list: _allFavorites));
      } else {
        emit(ShowFavoriteMoviesFailedState(msg: "حدث خطا اثناء جلب البيانات"));
      }
    } catch (ex) {
      emit(ShowFavoriteMoviesFailedState(msg: ex.toString()));
    }
  }





  Future<void> _filterShowFavoriteByGenre(FilterShowFavoriteMoviesByGenreEvent event, Emitter<ShowFavoriteMoviesStates> emit) async{
    try{
      final filteredList = _allFavorites.where((movie) {
        return movie.genreIds.contains(event.genreId);
      }).toList();
      emit(ShowFavoriteMoviesSuccessState(list: filteredList));
    }catch (ex) {
      emit(ShowFavoriteMoviesFailedState(msg: "خطأ أثناء الفلترة: ${ex.toString()}"));
    }
  }
}


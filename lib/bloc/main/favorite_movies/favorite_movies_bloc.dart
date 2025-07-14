import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/util/dio_helper.dart';

part 'favorite_movies_event.dart';

part 'favorite_movies_state.dart';

class AddFavoriteMoviesBloc
    extends Bloc<AddFavoriteMoviesEvents, AddFavoriteMoviesStates> {
  AddFavoriteMoviesBloc() : super(AddFavoriteMoviesInitState()) {
    on<AddFavoriteEvent>(_addToFavorite);
  }

  Future<void> _addToFavorite(AddFavoriteEvent event,
      Emitter<AddFavoriteMoviesStates> emit) async {
    try {
      final favoriteResponse = await DioHelper.post(
          'account/22093634/favorite', data: {
        "media_type": "movie",
        "media_id": event.id,
        "favorite": event.isFavs
      }
      );
      if (favoriteResponse.isSuccess) {
        emit(AddFavoriteMoviesSuccessState(isFavs: event.isFavs));
      } else {
        emit(AddFavoriteMoviesFailedState(msg: "حدث خطا اثناء جلب البيانات"));
      }
    } catch (ex) {
      emit(AddFavoriteMoviesFailedState(msg: ex.toString()));
    }
  }



}


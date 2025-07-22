import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:movie_app/core/data/dio_helper.dart';
import 'package:movie_app/features/genres/model/genres_model.dart';

import '../../../core/widgets/app_exception.dart';
part 'genres_movies_event.dart';
part 'genres_movies_state.dart';

class GenresMoviesBloc extends Bloc<GenresEvents, GenresStates>{
  GenresMoviesBloc() : super(GenresInitialState()) {
    on<GetGenresEvent>(_onGetGenres);
  }

  Future<void> _onGetGenres(GetGenresEvent event, Emitter<GenresStates> emit) async {
    try {
      final response = await DioHelper.get("genre/movie/list");
      if (response.isSuccess) {
        final model = GenreMoviesData.fromJson(response.data);
        emit(GenresSuccessState(list: model.list));
      } else {
        throw AppException("فشل تحميل قائمة الأنواع من الخادم.");
      }
    } on AppException catch (e) {
      emit(GenresErrorState(msg: e.message));
    } catch (e) {
      emit(GenresErrorState(msg: "حدث خطأ أثناء تحميل الأنواع. حاول لاحقًا."));
    }
  }
}

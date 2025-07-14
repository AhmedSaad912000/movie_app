import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:movie_app/core/util/dio_helper.dart';
import 'package:movie_app/models/genres_model.dart';
part 'genres_movies_event.dart';
part 'genres_movies_state.dart';

class GenresMoviesBloc extends Bloc<GenresEvents, GenresStates>{
  GenresMoviesBloc() : super(GenresInitialState()) {
    on<GetGenresEvent>(_onGetGenres);



  }

  Future<void> _onGetGenres(GetGenresEvent event, Emitter<GenresStates> emit) async{
    try{
      final response= await DioHelper.get("genre/movie/list");
      if(response.isSuccess){
        final  model= GenreMoviesData.fromJson(response.data);
        emit(GenresSuccessState(list:model.list));
      }else {
        emit(GenresErrorState(msg: "فشل تحميل الأنواع"));
      }
    }catch (ex) {
      emit(GenresErrorState(msg: "حدث خطأ أثناء تحميل الأنواع"));
    }
  }
}

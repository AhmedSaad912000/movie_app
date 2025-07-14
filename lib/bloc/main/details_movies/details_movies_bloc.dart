import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/util/dio_helper.dart';
import 'package:movie_app/models/details_movie_model.dart';
part 'details_movies_event.dart';
part 'details_movies_state.dart';
class DetailsMoviesBloc extends Bloc<DetailsMoviesEvents, DetailsMoviesStates> {
  DetailsMoviesBloc() : super(DetailsMoviesStates()) {
    on<GetDetailsMovieEvent>(_getData);
  }

  Future<void> _getData(GetDetailsMovieEvent event, Emitter<DetailsMoviesStates> emit) async{
    emit (DetailsMovieStateLoading());
    final response =await DioHelper.get("movie/${event.id.toString()}");
    if(response.isSuccess){
      final model=DetailsMovieData.fromJson(response.data);
      emit(DetailsMovieStateSuccess(model: model));
    }else{
      emit(DetailsMovieStateFailed(msg: response.msg));
    }

  }
}

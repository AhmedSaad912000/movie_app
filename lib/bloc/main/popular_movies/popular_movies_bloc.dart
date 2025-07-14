import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/util/dio_helper.dart';
import '../../../models/popular_movies_model.dart';
part 'popular_movies_event.dart';
part 'popular_movies_state.dart';

class PoplarMoviesBloc extends Bloc<PopularMovieEvents, PopularMoviesStates> {
  PoplarMoviesBloc() : super(PopularMoviesStates()) {
    on<GetPopularMovieEvent>(_GetPopularMovies);
  }

  Future<void> _GetPopularMovies(
      GetPopularMovieEvent event,
      Emitter<PopularMoviesStates> emit,
      ) async {
    try{
      final response=await DioHelper.get('movie/popular');
      if(response.isSuccess){
        final model=PopularMoviesData.fromJson(response.data);
        emit(PopularSuccessState(list: model.list));
      }else{
        emit(PopularFailedState(msg: "حدث خطا اثناء جلب البيانات"));
      }
    }catch(ex){
      emit(PopularFailedState(msg:ex.toString()));
    }



  }
}

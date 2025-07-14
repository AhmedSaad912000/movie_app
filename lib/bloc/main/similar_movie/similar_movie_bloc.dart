import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/util/dio_helper.dart';
import '../../../models/similar_movie_model.dart';
part 'similar_movie_event.dart';
part 'similar_movie_state.dart';
class SimilarMovieBloc extends Bloc<SimilarMovieEvents,SimilarMovieStates>{
  SimilarMovieBloc():super(SimilarMovieStates()){
    on<SimilarMovieEvent>(_GetSimilarMovie);
  }


  Future<void> _GetSimilarMovie(SimilarMovieEvent event, Emitter<SimilarMovieStates> emit) async{
    try{
      final response=await DioHelper.get('movie/${event.id}/similar');
      if(response.isSuccess){
        final model = SimilarMovieData.fromJson(response.data);
        emit(SimilarMovieSuccessState(list: model.list));
      }else{
        emit(SimilarMovieFailedState(msg: "حدث خطا اثناء جلب البيانات"));
      }
    }catch(ex){
      emit(SimilarMovieFailedState(msg: ex.toString()));
    }


  }
}
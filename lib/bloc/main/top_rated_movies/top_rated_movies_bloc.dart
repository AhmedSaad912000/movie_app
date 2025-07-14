import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/util/dio_helper.dart';
import '../../../models/top_rated_movie_model.dart';

part 'top_rated_movies_event.dart';

part 'top_rated_movies_state.dart';

class TopRatedMovieBloc extends Bloc<TopRatedEvents, TopRatedStates> {
  int page = 1;
  final int limit = 20;
  bool isFetching = false;

  TopRatedMovieBloc() : super(TopRatedStates()) {
    on<RefreshRatedEvent>(_refreshTopRatedMovies);
    on<TopRatedEvent>(_getTopRatedMovies);
    on<FilterTopRatedMoviesByGenreEvent>(_filterTopRatedByGenre);
  }

  Future<void> _refreshTopRatedMovies(RefreshRatedEvent event, Emitter<TopRatedStates> emit) async {
    page = 1;
    isFetching = true;
    try {
      final response = await DioHelper.get('movie/top_rated',data: {'page': page});
      if (response.isSuccess) {
        final model = TopRatedMoviesData.fromJson(response.data);
        final newMovies = model.list;
        page++;
        emit(TopRatedSuccessState(
          list: newMovies, hasReachedMax: newMovies.length < limit,
        ));
      } else {
        emit(TopRatedFailedState(msg: "حدث خطا في جلب البيانات "));
      }
    } catch (ex) {
      emit(TopRatedFailedState(msg: ex.toString()));
    }
    isFetching = false;

  }

  Future<void> _getTopRatedMovies(TopRatedEvent event, Emitter<TopRatedStates> emit)async {
    if (isFetching) return;
    isFetching = true;
    try{
      final response=await DioHelper.get("movie/top_rated",data: {"page":page});
      if(response.isSuccess){
        final model=TopRatedMoviesData.fromJson(response.data);
        final newMovies=model.list;
        page++;
        final currentState = state;
        if (currentState is TopRatedSuccessState) {
          final updatedList = List.of(currentState.list)..addAll(newMovies);
          emit(TopRatedSuccessState(
            list: updatedList,
            hasReachedMax: newMovies.length < limit,
          ));
        }else{
          emit(TopRatedSuccessState(list: newMovies, hasReachedMax: newMovies.length<limit));
        }
      }else{
        emit(TopRatedFailedState(msg: "حدث خطا في جلب البيانات "));
      }

    }catch(ex){
      emit(TopRatedFailedState(msg: ex.toString()));
    }
    isFetching=false;
  }

  Future<void> _filterTopRatedByGenre(FilterTopRatedMoviesByGenreEvent event, Emitter<TopRatedStates> emit) async{
    try{
      final response= await DioHelper.get('discover/movie',data: {
        'with_genres': event.genreId,});
      if(response.isSuccess){
        final model = TopRatedMoviesData.fromJson(response.data);
        emit (TopRatedSuccessState(list: model.list, hasReachedMax:  model.list.length < limit));
      }else{
        emit(TopRatedFailedState(msg: "فشل في تحميل افلام هذا النوع "));
      }
    }catch(ex){
      emit(TopRatedFailedState(msg: ex.toString()));
    }
  }
}

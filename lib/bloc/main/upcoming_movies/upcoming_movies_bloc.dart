import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/util/dio_helper.dart';
import '../../../models/upcoming_movies_model.dart';

part 'upcoming_movies_event.dart';

part 'upcoming_movies_state.dart';

class UpcomingMovieBloc extends Bloc<UpComingEvents, UpComingStates> {
  int page = 1;
  final int limit = 20;
  bool isFetching = false;

  UpcomingMovieBloc() :super(UpComingStates()) {
    on<RefreshUpcomingEvent>(_refreshUpComingMovies);
    on<UpComingEvent>(_getUpcomingMovies);
    on<FilterUpcomingMoviesByGenreEvent>(_filterUpcomingByGenre);


  }


  Future<void> _refreshUpComingMovies(RefreshUpcomingEvent event,
      Emitter<UpComingStates> emit) async {
    page = 1;
    isFetching = true;
    try{
      final response = await DioHelper.get('movie/upcoming', data: { 'page': page });
      if (response.isSuccess) {
        final model = UpcomingMovieData.fromJson(response.data);
        final newMovies = model.list;
        page++;
        emit(UpComingSuccessState(list: newMovies, hasReachedMax: newMovies.length < limit,),);
      }else {
        emit(UpComingErrorState(msg: 'حدث خطأ أثناء جلب البيانات'));
      }
    }catch(ex){
      emit(UpComingErrorState(msg:ex.toString()));

    }
    isFetching = false;
  }


  Future<void> _getUpcomingMovies(UpComingEvent event, Emitter<UpComingStates> emit) async{
    if (isFetching) return;
    isFetching = true;
    try {
      final response = await DioHelper.get('movie/upcoming', data: {'page': page});
      if (response.isSuccess) {
        final model = UpcomingMovieData.fromJson(response.data);
        final newMovies = model.list ;
        final currentState = state;
        List<MovieUpComingModel> updatedList = [];
        if (currentState is UpComingSuccessState) {
          updatedList = List.from(currentState.list)..addAll(newMovies);
        } else {
          updatedList = newMovies;
        }
        page++;
        emit(UpComingSuccessState(
          list: updatedList,
          hasReachedMax: newMovies.length < limit,

        ));
      } else {
        emit(UpComingErrorState(msg: 'حدث خطأ أثناء تحميل البيانات'));
      }
    }  catch (ex) {
      emit(UpComingErrorState(msg: ex.toString()));


  }
      isFetching = false;


  }

  Future<void> _filterUpcomingByGenre(FilterUpcomingMoviesByGenreEvent event, Emitter<UpComingStates> emit)async {
    try {
      final response = await DioHelper.get('discover/movie', data: {
        'with_genres': event.genreId,
      });

      if (response.isSuccess) {
        final model = UpcomingMovieData.fromJson(response.data);
        emit(UpComingSuccessState(list: model.list, hasReachedMax: model.list.length < limit));
      } else {
        emit(UpComingErrorState(msg: 'فشل في تحميل أفلام  هذاالنوع'));
      }
    } catch (ex) {
      emit(UpComingErrorState(msg: ex.toString()));
    }
  }
}
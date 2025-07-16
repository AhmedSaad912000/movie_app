import 'package:kiwi/kiwi.dart';
import 'package:movie_app/bloc/main/similar_movie/similar_movie_bloc.dart';

import '../core/data/movie_repository.dart';
import '../core/data/movie_repository_base.dart';
import 'main/details_movies/details_movies_bloc.dart';
import 'main/favorite_movies/favorite_movies_bloc.dart';
import 'main/genres_movies/genres_movies_bloc.dart';
import 'main/popular_movies/popular_movies_bloc.dart';
import 'main/show_favorite_movies/show_favorite_movies_bloc.dart';
import 'main/top_rated_movies/top_rated_movies_bloc.dart';
import 'main/upcoming_movies/upcoming_movies_bloc.dart';

void initKiwi() {
  final container = KiwiContainer();

  container.registerFactory<MovieRepositoryBase>((container) => MovieRepositoryImpl());

  container.registerFactory((container) => PoplarMoviesBloc());
  container.registerFactory((container) => UpcomingMovieBloc(repository: container<MovieRepositoryBase>()));
  container.registerFactory((container) => TopRatedMovieBloc(repository: container<MovieRepositoryBase>()));
  container.registerFactory((container) => DetailsMoviesBloc(movieRepository: container<MovieRepositoryBase>()));
  container.registerFactory((container) => SimilarMovieBloc(movieRepository: container<MovieRepositoryBase>()));
  container.registerFactory((container) => AddFavoriteMoviesBloc(movieRepository: container<MovieRepositoryBase>()));
  container.registerSingleton((container) => ShowFavoriteMoviesBloc(movieRepository: container<MovieRepositoryBase>()));
  container.registerSingleton((container) => GenresMoviesBloc());
}

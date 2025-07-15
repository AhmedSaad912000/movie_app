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

  container.registerFactory<MovieRepositoryBase>((c) => MovieRepositoryImpl());

  container.registerFactory((c) => PoplarMoviesBloc());
  container.registerFactory((c) => UpcomingMovieBloc(repository: c<MovieRepositoryBase>()));
  container.registerFactory((c) => TopRatedMovieBloc(repository: c<MovieRepositoryBase>()));
  container.registerFactory((c) => DetailsMoviesBloc(movieRepository: c<MovieRepositoryBase>()));
  container.registerFactory((c) => SimilarMovieBloc(movieRepository: c<MovieRepositoryBase>()));
  container.registerFactory((c) => AddFavoriteMoviesBloc(movieRepository: c<MovieRepositoryBase>()));
  container.registerSingleton((c) => ShowFavoriteMoviesBloc(movieRepository: c<MovieRepositoryBase>()));
  container.registerSingleton((c) => GenresMoviesBloc());
}

import 'package:kiwi/kiwi.dart';

import '../../features/add_favorite/bloc/favorite_movies_bloc.dart';
import '../../features/add_favorite/data/add_favorite_movies_repo_base.dart';
import '../../features/add_favorite/data/add_favorites_repository.dart';
import '../../features/favorites/bloc/show_favorite_movies_bloc.dart';
import '../../features/favorites/data/favorite_movies_repo_base.dart';
import '../../features/favorites/data/favorite_movies_repository.dart';
import '../../features/genres/bloc/genres_movies_bloc.dart';
import '../../features/movie_details/bloc/details_movies_bloc.dart';
import '../../features/movie_details/bloc/similar_movies/similar_movie_bloc.dart';
import '../../features/movie_details/data/movie_details_repo_base.dart';
import '../../features/movie_details/data/movie_details_repository.dart';
import '../../features/popular_movies/bloc/popular_movies_bloc.dart';
import '../../features/popular_movies/data/popular_movies_repo_base.dart';
import '../../features/popular_movies/data/popular_movies_repository.dart';
import '../../features/top_rated_movies/bloc/top_rated_movies_bloc.dart';
import '../../features/top_rated_movies/data/top_rated_movies_repo_base.dart';
import '../../features/top_rated_movies/data/top_rated_movies_repository.dart';
import '../../features/upcoming_movies/bloc/upcoming_movies_bloc.dart';
import '../../features/upcoming_movies/data/upcoming_movies_repo_base.dart';
import '../../features/upcoming_movies/data/upcoming_movies_repository.dart';
import 'dio_helper.dart';

void initKiwi() {
  final container = KiwiContainer();
  // DioHelper
  container.registerSingleton((c) => DioHelper());
  // ✅ تسجيل الـ Repositories
  container.registerFactory<PopularMoviesRepo>((c) => PopularMoviesRepoImpl(),);
  container.registerFactory<UpcomingMoviesRepo>((c) => UpcomingMoviesRepoImpl(),);
  container.registerFactory<TopRatedMoviesRepo>((c) => TopRatedMoviesRepoImpl(),);
  container.registerFactory<MovieDetailsRepo>((c) => MovieDetailsRepository(),);
  container.registerFactory<AddFavoriteMoviesRepositoryBase>((c) => AddFavoriteRepository(),);
  container.registerFactory<FavoriteMoviesRepositoryBase>((c) => FavoriteMoviesRepository(),);
  // ✅ تسجيل الـ BLoCs
  container.registerFactory((c) => PoplarMoviesBloc(repository: c<PopularMoviesRepo>()),);
  container.registerFactory((c) => UpcomingMovieBloc(repository: c<UpcomingMoviesRepo>()),);
  container.registerFactory((c) => TopRatedMovieBloc(repository: c<TopRatedMoviesRepo>()),);
  container.registerFactory((c) => DetailsMoviesBloc(movieRepository: c<MovieDetailsRepo>()),);
  container.registerFactory((c) => SimilarMovieBloc(movieRepository: c<MovieDetailsRepo>()),);
  container.registerFactory(
        (c) => AddFavoriteMoviesBloc(
      movieRepository: c<AddFavoriteMoviesRepositoryBase>(),
      movieDetailsRepo: c<MovieDetailsRepo>(),
    ),
  );  container.registerSingleton((c) => ShowFavoriteMoviesBloc(movieRepository: c<FavoriteMoviesRepositoryBase>()),);
  container.registerSingleton((c) => GenresMoviesBloc());
}

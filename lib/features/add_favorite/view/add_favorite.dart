import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/features/add_favorite/bloc/favorite_movies_bloc.dart';
import 'package:movie_app/features/favorites/bloc/show_favorite_movies_bloc.dart';

class FavoriteButton extends StatefulWidget {
  final int movieId;

  const FavoriteButton({Key? key, required this.movieId}) : super(key: key);

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  final addFavoriteBloc = KiwiContainer().resolve<AddFavoriteMoviesBloc>();
  final showFavoriteMovie = KiwiContainer().resolve<ShowFavoriteMoviesBloc>();

  @override
  void initState() {
    super.initState();
    showFavoriteMovie.add(ShowFavoriteMoviesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddFavoriteMoviesBloc, AddFavoriteMoviesStates>(
      bloc: addFavoriteBloc,
      listener: (context, state) {
        if (state is AddFavoriteMoviesSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.isFavs
                  ? 'تمت الإضافة إلى المفضلة ❤️'
                  : 'تمت الإزالة من المفضلة ❌'),
              duration: Duration(milliseconds: 400),
            ),
          );
        } else if (state is AddFavoriteMoviesFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('حدث خطأ: ${state.msg}')),
          );
        }
      },
      builder: (context, state) {
        bool isFav = false;
        if (state is AddFavoriteMoviesSuccessState) {
          isFav = state.isFavs;
        }
        return BlocBuilder<ShowFavoriteMoviesBloc, ShowFavoriteMoviesStates>(
          bloc: showFavoriteMovie,
          builder: (context, favState) {
            if (favState is ShowFavoriteMoviesSuccessState) {
              isFav = favState.list.any((movie) => movie.id == widget.movieId);
            }
            return IconButton(
              icon: Icon(
                Icons.favorite,
                color: isFav ? Colors.red : Colors.white,
                size: 30.sp,
              ),
              onPressed: () {
                addFavoriteBloc.add(
                  AddFavoriteEvent(id: widget.movieId, isFavs: !isFav),
                );

                Future.delayed(const Duration(milliseconds: 300), () {
                  showFavoriteMovie.add(ShowFavoriteMoviesEvent());
                });
              },
            );
          },
        );
      },
    );
  }
}

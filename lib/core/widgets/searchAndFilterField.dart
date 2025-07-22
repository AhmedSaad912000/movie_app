import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../features/genres/view/show_movie_sheet.dart';
class SearchAndFilterField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final List<Genre> genres;
  final Function(Genre) onSelectedGenre;
  final String? selectedGenreName;

  const SearchAndFilterField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.genres,
    required this.onSelectedGenre,
    this.selectedGenreName,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w500,
      ),
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        suffixIcon: Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Colors.black,
          ),
          child: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => ShowMovieSheet(
                  selectedType: selectedGenreName,
                  genres: genres,
                  onSelected: onSelectedGenre,
                ),
              );
            },
            icon: Icon(
              Icons.filter_list,
              color: Colors.white,
            ),
          ),
        ),
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: Colors.grey)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: Colors.grey)),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ShowMovieSheet extends StatelessWidget {
  final List<Genre> genres;
  final Function(Genre) onSelected;
  final String? selectedType;
  const ShowMovieSheet({
    Key? key,
    required this.genres,
    required this.onSelected,required this.selectedType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.all(5.r),
      backgroundColor: Colors.brown,
      children: [
        SizedBox(
          height: 300.h,
          width: double.infinity,
          child: ListView.builder(
            itemCount: genres.length,
            itemBuilder: (context, index) {
              final type = genres[index];
              return Column(
                children: [
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    selectedTileColor: Colors.green[700],
                    selectedColor: Colors.white,
                    title: Text(type.name,textAlign: TextAlign.center,style: TextStyle(
                      fontSize: 20.sp,
                    ),),
                    selected: type.name == selectedType,
                    onTap: () {
                      Navigator.pop(context);
                      onSelected(type);
                    },
                  ),
                  Divider(thickness: 3)
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
class Genre {
  final int id;
  final String name;
  Genre({required this.id, required this.name});
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/widgets/app_image.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppImage(
                "internet_error.png",
                width: 450.w,
                height: 450.h,
                fit: BoxFit.fill,
              ),
              SizedBox(height: 40.h),
              Text(
                "No Internet Connection",
                style: TextStyle(fontSize: 20.sp, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class AppFailed extends StatelessWidget {
  final String msg;
  const AppFailed({super.key, required this.msg});
  @override
  Widget build(BuildContext context) {
    return Text(msg,style: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black
    ),);
  }
}

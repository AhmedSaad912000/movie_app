import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:movie_app/core/util/helper_methods.dart';
import 'package:movie_app/views/main/home/view.dart';
import 'bloc/kiwi.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const MyApp());
  initKiwi();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
      return  MaterialApp(
        navigatorKey:navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'MovieApp',
          theme: ThemeData(
            fontFamily: "Poppins",
            scaffoldBackgroundColor: Colors.grey[700],
            appBarTheme: AppBarTheme(
              color:  Colors.transparent,
            ),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white,primary: Colors.white),
            useMaterial3: true,
          ),
          home: child,
        );
      },
      child: const HomeView(),
    );
  }
}



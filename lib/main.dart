import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:movie_app/core/data/kiwi.dart';
import 'package:movie_app/core/util/helper_methods.dart';
import 'package:movie_app/features/home/view.dart';
import 'local_provider/movie_hive_model.dart';
import 'local_provider/movie_list_cache_model.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MovieModelAdapter());
  Hive.registerAdapter(MovieListCacheModelAdapter());
  initKiwi();
  runApp(const MyApp());
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



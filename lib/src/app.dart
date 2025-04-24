// lib/src/app.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydroleaf_app/src/services/api_service.dart';
import 'routes.dart';

class HydroleafApp extends StatelessWidget {
  final ApiService apiService;
  const HydroleafApp({Key? key, required this.apiService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (_, __) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hydroleaf',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF00A86B),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        initialRoute: Routes.login,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}

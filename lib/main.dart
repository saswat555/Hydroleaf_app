// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'src/app.dart';
import 'src/services/api_service.dart';
import 'src/providers/auth_provider.dart';
import 'src/providers/farm_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // use `10.0.2.2` for Android emulator → maps to localhost of host machine
  final apiService = ApiService(baseUrl: 'http://localhost:3000');

  runApp(
    MultiProvider(
      providers: [
        // 1) Make ApiService available throughout the widget tree
        Provider<ApiService>.value(value: apiService),

        // 2) User auth + token
        ChangeNotifierProvider(
          create: (_) => AuthProvider(apiService: apiService),
        ),

        // 3) FarmProvider depends on AuthProvider for the token
        ChangeNotifierProxyProvider<AuthProvider, FarmProvider>(
          create: (_) => FarmProvider(apiService: apiService, token: ''),
          update: (_, auth, farm) => farm!..updateToken(auth.token ?? ''),
        ),
      ],
      // Pass the apiService into HydroleafApp
      child: HydroleafApp(apiService: apiService),
    ),
  );
}

/// lib/src/routes.dart

import 'package:flutter/material.dart';
import 'package:hydroleaf_app/src/services/api_service.dart';
import 'package:hydroleaf_app/src/services/models.dart';

// Screens
import 'ui/screens/login_screen.dart';
import 'ui/screens/register_screen.dart';
import 'ui/screens/dashboard_screen.dart';
import 'ui/screens/farm_list_screen.dart';
import 'ui/screens/register_farm_screen.dart';
import 'ui/screens/farm_detail_screen.dart';
import 'ui/screens/device_list_screen.dart';
import 'ui/screens/register_device_screen.dart';
import 'ui/screens/device_detail_screen.dart';
import 'ui/screens/sensor_screen.dart';
import 'ui/screens/dosing_screen.dart';
import 'ui/screens/settings_screen.dart';

abstract class Routes {
  static const String login = '/';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String farmList = '/farms';
  static const String registerFarm = '/farms/register';
  static const String farmDetail = '/farms/detail';
  static const String deviceList = '/devices';
  static const String registerDevice = '/devices/register';
  static const String deviceDetail = '/devices/detail';
  static const String sensor = '/devices/sensor';
  static const String dosing = '/devices/dosing';
  static const String settings = '/settings';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>? ?? {};

    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case Routes.register:
        return MaterialPageRoute(
          builder: (_) => RegisterScreen(
            apiService: args['apiService'] as ApiService,
          ),
        );

      case Routes.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());

      case Routes.farmList:
        // FarmListScreen has no ctor params
        return MaterialPageRoute(builder: (_) => const FarmListScreen());

      case Routes.registerFarm:
        return MaterialPageRoute(
          builder: (_) => RegisterFarmScreen(
            apiService: args['apiService'] as ApiService,
            token: args['token'] as String,
          ),
        );

      case Routes.farmDetail:
        return MaterialPageRoute(
          builder: (_) => FarmDetailScreen(
            farmId: args['farmId'] as int,
          ),
        );

      case Routes.deviceList:
        return MaterialPageRoute(
          builder: (_) => DeviceListScreen(
            apiService: args['apiService'] as ApiService,
            token: args['token'] as String,
          ),
        );

      case Routes.registerDevice:
        return MaterialPageRoute(
          builder: (_) => RegisterDeviceScreen(
            apiService: args['apiService'] as ApiService,
            token: args['token'] as String,
          ),
        );

      case Routes.deviceDetail:
        return MaterialPageRoute(
          builder: (_) => DeviceDetailScreen(
            api: args['apiService']
                as ApiService, // <— use `api:`, not `apiService:`
            token: args['token'] as String,
            device: args['device'] as DeviceResponse,
          ),
        );

      case Routes.sensor:
        return MaterialPageRoute(
          builder: (_) => SensorScreen(
            api: args['apiService'] as ApiService,
            token: args['token'] as String,
            device: args['device'] as DeviceResponse,
          ),
        );

      case Routes.dosing:
        return MaterialPageRoute(
          builder: (_) => DosingScreen(
            api: args['apiService'] as ApiService,
            token: args['token'] as String,
            deviceId: args['deviceId'] as int,
          ),
        );

      case Routes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No route defined for this path')),
          ),
        );
    }
  }
}

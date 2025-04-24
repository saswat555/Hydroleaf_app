// lib/src/providers/auth_provider.dart
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService apiService;
  String? _token;

  AuthProvider({required this.apiService});

  bool get isAuthenticated => _token != null;
  String? get token => _token;

  Future<void> login(String email, String password) async {
    _token = await apiService.login(email, password);
    notifyListeners();
  }
}

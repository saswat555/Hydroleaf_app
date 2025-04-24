// lib/src/providers/farm_provider.dart
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../services/models.dart';

class FarmProvider extends ChangeNotifier {
  final ApiService apiService;
  String token;
  List<Farm> _farms = [];

  FarmProvider({required this.apiService, required this.token});

  List<Farm> get farms => _farms;
  void updateToken(String newToken) {
    if (newToken == token) return;
    token = newToken;
    notifyListeners();
  }

  Future<void> loadFarms() async {
    _farms = await apiService.fetchFarms(token);
    notifyListeners();
  }
}

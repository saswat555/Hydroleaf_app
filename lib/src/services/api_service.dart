// lib/src/services/api_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';

class ApiService {
  final String baseUrl;
  final Duration _timeout = const Duration(seconds: 10);

  ApiService({required this.baseUrl});

  Map<String, String> _jsonHeaders([String? token]) {
    final headers = {'Content-Type': 'application/json'};
    if (token != null) headers['Authorization'] = 'Bearer $token';
    return headers;
  }

  // ─── AUTH ───────────────────────────────────────────────────────────────

  /// Returns access token
  Future<String> login(String email, String password) async {
    final uri = Uri.parse('$baseUrl/api/v1/auth/login');
    final resp = await http.post(uri,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'username': email, 'password': password}).timeout(_timeout);
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);
      return data['access_token'] as String;
    }
    throw ApiException(resp.statusCode, resp.body);
  }

  Future<User> signup(UserCreate dto) async {
    final uri = Uri.parse('$baseUrl/api/v1/auth/signup');
    final resp = await http
        .post(uri, headers: _jsonHeaders(), body: jsonEncode(dto.toJson()))
        .timeout(_timeout);
    if (resp.statusCode == 200 || resp.statusCode == 201) {
      return User.fromJson(json.decode(resp.body));
    }
    throw ApiException(resp.statusCode, resp.body);
  }

  // ─── FARMS ──────────────────────────────────────────────────────────────

  Future<List<Farm>> fetchFarms(String token) async {
    final uri = Uri.parse('$baseUrl/api/v1/farms');
    final resp =
        await http.get(uri, headers: _jsonHeaders(token)).timeout(_timeout);
    if (resp.statusCode == 200) {
      final list = json.decode(resp.body) as List;
      return list.map((e) => Farm.fromJson(e)).toList();
    }
    throw ApiException(resp.statusCode, resp.body);
  }

  Future<Farm> createFarm(String token, FarmCreate dto) async {
    final uri = Uri.parse('$baseUrl/api/v1/farms');
    final resp = await http
        .post(uri, headers: _jsonHeaders(token), body: jsonEncode(dto.toJson()))
        .timeout(_timeout);
    if (resp.statusCode == 200 || resp.statusCode == 201) {
      return Farm.fromJson(json.decode(resp.body));
    }
    throw ApiException(resp.statusCode, resp.body);
  }

  Future<void> deleteFarm(String token, int farmId) async {
    final uri = Uri.parse('$baseUrl/api/v1/farms/$farmId');
    final resp =
        await http.delete(uri, headers: _jsonHeaders(token)).timeout(_timeout);
    if (resp.statusCode != 200) {
      throw ApiException(resp.statusCode, resp.body);
    }
  }

  // ─── DEVICES ────────────────────────────────────────────────────────────

  Future<List<DeviceResponse>> fetchDevices(String token) async {
    final uri = Uri.parse('$baseUrl/api/v1/devices');
    final resp =
        await http.get(uri, headers: _jsonHeaders(token)).timeout(_timeout);
    if (resp.statusCode == 200) {
      final list = json.decode(resp.body) as List;
      return list.map((e) => DeviceResponse.fromJson(e)).toList();
    }
    throw ApiException(resp.statusCode, resp.body);
  }

  Future<DeviceResponse> registerDosingDevice(
      String token, DosingDeviceCreate dto) async {
    final uri = Uri.parse('$baseUrl/api/v1/devices/dosing');
    final resp = await http
        .post(uri, headers: _jsonHeaders(token), body: jsonEncode(dto.toJson()))
        .timeout(_timeout);
    if (resp.statusCode == 200 || resp.statusCode == 201) {
      return DeviceResponse.fromJson(json.decode(resp.body));
    }
    throw ApiException(resp.statusCode, resp.body);
  }

  Future<DeviceResponse> registerSensorDevice(
      String token, SensorDeviceCreate dto) async {
    final uri = Uri.parse('$baseUrl/api/v1/devices/sensor');
    final resp = await http
        .post(uri, headers: _jsonHeaders(token), body: jsonEncode(dto.toJson()))
        .timeout(_timeout);
    if (resp.statusCode == 200 || resp.statusCode == 201) {
      return DeviceResponse.fromJson(json.decode(resp.body));
    }
    throw ApiException(resp.statusCode, resp.body);
  }

  Future<SensorReading> fetchSensorData(String token, int deviceId) async {
    final uri = Uri.parse('$baseUrl/api/v1/devices/sensoreading/$deviceId');
    final resp =
        await http.get(uri, headers: _jsonHeaders(token)).timeout(_timeout);
    if (resp.statusCode == 200) {
      return SensorReading.fromJson(json.decode(resp.body));
    }
    throw ApiException(resp.statusCode, resp.body);
  }

  // ─── DOSING ─────────────────────────────────────────────────────────────

  Future<DosingOperation> executeDosing(String token, int deviceId) async {
    final uri = Uri.parse('$baseUrl/api/v1/dosing/execute/$deviceId');
    final resp =
        await http.post(uri, headers: _jsonHeaders(token)).timeout(_timeout);
    if (resp.statusCode == 200) {
      return DosingOperation.fromJson(json.decode(resp.body));
    }
    throw ApiException(resp.statusCode, resp.body);
  }

  Future<void> cancelDosing(String token, int deviceId) async {
    final uri = Uri.parse('$baseUrl/api/v1/dosing/cancel/$deviceId');
    final resp =
        await http.post(uri, headers: _jsonHeaders(token)).timeout(_timeout);
    if (resp.statusCode != 200) {
      throw ApiException(resp.statusCode, resp.body);
    }
  }

  Future<List<DosingOperation>> fetchDosingHistory(
      String token, int deviceId) async {
    final uri = Uri.parse('$baseUrl/api/v1/dosing/history/$deviceId');
    final resp =
        await http.get(uri, headers: _jsonHeaders(token)).timeout(_timeout);
    if (resp.statusCode == 200) {
      final list = json.decode(resp.body) as List;
      return list.map((e) => DosingOperation.fromJson(e)).toList();
    }
    throw ApiException(resp.statusCode, resp.body);
  }

  Future<DosingProfile> createDosingProfile(
      String token, DosingProfileCreate dto) async {
    final uri = Uri.parse('$baseUrl/api/v1/dosing/profile');
    final resp = await http
        .post(uri, headers: _jsonHeaders(token), body: jsonEncode(dto.toJson()))
        .timeout(_timeout);
    if (resp.statusCode == 200 || resp.statusCode == 201) {
      return DosingProfile.fromJson(json.decode(resp.body));
    }
    throw ApiException(resp.statusCode, resp.body);
  }

  Future<List<DosingProfile>> fetchDosingProfiles(
      String token, int deviceId) async {
    final uri = Uri.parse('$baseUrl/api/v1/config/dosing-profiles/$deviceId');
    final resp =
        await http.get(uri, headers: _jsonHeaders(token)).timeout(_timeout);
    if (resp.statusCode == 200) {
      final list = json.decode(resp.body) as List;
      return list.map((e) => DosingProfile.fromJson(e)).toList();
    }
    throw ApiException(resp.statusCode, resp.body);
  }

  // ─── SUPPLY CHAIN ───────────────────────────────────────────────────────

  Future<SupplyChainAnalysis> analyzeSupplyChain(
      String token, TransportRequest dto) async {
    final uri = Uri.parse('$baseUrl/api/v1/supply_chain');
    final resp = await http
        .post(uri, headers: _jsonHeaders(token), body: jsonEncode(dto.toJson()))
        .timeout(_timeout);
    if (resp.statusCode == 200) {
      return SupplyChainAnalysis.fromJson(json.decode(resp.body));
    }
    throw ApiException(resp.statusCode, resp.body);
  }
}

/// Thrown for any non-200 response.
class ApiException implements Exception {
  final int statusCode;
  final String body;
  ApiException(this.statusCode, this.body);
  @override
  String toString() =>
      'ApiException($statusCode): ${body.length > 200 ? '${body.substring(0, 200)}…' : body}';
}

// lib/src/services/models.dart

/// ─── AUTH & USER ─────────────────────────────────────────────────────────

class User {
  final int id;
  final String email;
  final String role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.email,
    required this.role,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int,
        email: json['email'] as String,
        role: json['role'] as String,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'role': role,
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
        if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
      };
}

class UserCreate {
  final String email;
  final String password;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;

  UserCreate({
    required this.email,
    required this.password,
    this.firstName,
    this.lastName,
    this.phone,
    this.address,
    this.city,
    this.state,
    this.country,
    this.postalCode,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (phone != null) 'phone': phone,
        if (address != null) 'address': address,
        if (city != null) 'city': city,
        if (state != null) 'state': state,
        if (country != null) 'country': country,
        if (postalCode != null) 'postal_code': postalCode,
      };
}

/// ─── FARM ────────────────────────────────────────────────────────────────

class Farm {
  final int id;
  final String name;
  final String? location;
  final int? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Farm({
    required this.id,
    required this.name,
    this.location,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory Farm.fromJson(Map<String, dynamic> json) => Farm(
        id: json['id'] as int,
        name: json['name'] as String,
        location: json['location'] as String?,
        userId: json['user_id'] as int?,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'location': location,
        'user_id': userId,
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
        if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
      };
}

class FarmCreate {
  final String name;
  final String? location;

  FarmCreate({required this.name, this.location});

  Map<String, dynamic> toJson() => {
        'name': name,
        'location': location,
      };
}

/// ─── DEVICES ─────────────────────────────────────────────────────────────

enum DeviceType {
  dosingUnit,
  phTdsSensor,
  environmentSensor,
  valveController,
}

extension DeviceTypeExt on DeviceType {
  String toApi() {
    switch (this) {
      case DeviceType.dosingUnit:
        return 'dosing_unit';
      case DeviceType.phTdsSensor:
        return 'ph_tds_sensor';
      case DeviceType.environmentSensor:
        return 'environment_sensor';
      case DeviceType.valveController:
        return 'valve_controller';
    }
  }

  static DeviceType fromApi(String s) {
    switch (s) {
      case 'dosing_unit':
        return DeviceType.dosingUnit;
      case 'ph_tds_sensor':
        return DeviceType.phTdsSensor;
      case 'environment_sensor':
        return DeviceType.environmentSensor;
      case 'valve_controller':
        return DeviceType.valveController;
      default:
        throw ArgumentError('Unknown device type: $s');
    }
  }
}

class PumpConfig {
  final int pumpNumber;
  final String chemicalName;
  final String? chemicalDescription;

  PumpConfig({
    required this.pumpNumber,
    required this.chemicalName,
    this.chemicalDescription,
  });

  factory PumpConfig.fromJson(Map<String, dynamic> json) => PumpConfig(
        pumpNumber: json['pump_number'] as int,
        chemicalName: json['chemical_name'] as String,
        chemicalDescription: json['chemical_description'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'pump_number': pumpNumber,
        'chemical_name': chemicalName,
        'chemical_description': chemicalDescription,
      };
}

class ValveConfig {
  final int valveId;
  final String? name;

  ValveConfig({required this.valveId, this.name});

  factory ValveConfig.fromJson(Map<String, dynamic> json) => ValveConfig(
        valveId: json['valve_id'] as int,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'valve_id': valveId,
        'name': name,
      };
}

class DeviceResponse {
  final int id;
  final String macId;
  final String name;
  final DeviceType type;
  final String httpEndpoint;
  final String? locationDescription;
  final bool isActive;
  final DateTime? lastSeen;
  final String? firmwareVersion;
  final int? farmId;
  final int? userId;
  final List<PumpConfig>? pumpConfigurations;
  final Map<String, dynamic>? sensorParameters;
  final List<ValveConfig>? valveConfigurations;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DeviceResponse({
    required this.id,
    required this.macId,
    required this.name,
    required this.type,
    required this.httpEndpoint,
    this.locationDescription,
    required this.isActive,
    this.lastSeen,
    this.firmwareVersion,
    this.farmId,
    this.userId,
    this.pumpConfigurations,
    this.sensorParameters,
    this.valveConfigurations,
    this.createdAt,
    this.updatedAt,
  });

  factory DeviceResponse.fromJson(Map<String, dynamic> json) => DeviceResponse(
        id: json['id'] as int,
        macId: json['mac_id'] as String,
        name: json['name'] as String,
        type: DeviceTypeExt.fromApi(json['type'] as String),
        httpEndpoint: json['http_endpoint'] as String,
        locationDescription: json['location_description'] as String?,
        isActive: json['is_active'] as bool,
        lastSeen: json['last_seen'] != null
            ? DateTime.parse(json['last_seen'] as String)
            : null,
        firmwareVersion: json['firmware_version'] as String?,
        farmId: json['farm_id'] as int?,
        userId: json['user_id'] as int?,
        pumpConfigurations: json['pump_configurations'] != null
            ? (json['pump_configurations'] as List)
                .map((e) => PumpConfig.fromJson(e))
                .toList()
            : null,
        sensorParameters: json['sensor_parameters'] as Map<String, dynamic>?,
        valveConfigurations: json['valve_configurations'] != null
            ? (json['valve_configurations'] as List)
                .map((e) => ValveConfig.fromJson(e))
                .toList()
            : null,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'mac_id': macId,
        'name': name,
        'type': type.toApi(),
        'http_endpoint': httpEndpoint,
        'location_description': locationDescription,
        'is_active': isActive,
        'last_seen': lastSeen?.toIso8601String(),
        'firmware_version': firmwareVersion,
        'farm_id': farmId,
        'user_id': userId,
        'pump_configurations':
            pumpConfigurations?.map((e) => e.toJson()).toList(),
        'sensor_parameters': sensorParameters,
        'valve_configurations':
            valveConfigurations?.map((e) => e.toJson()).toList(),
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}

abstract class DeviceCreateBase {
  final String macId;
  final String name;
  final DeviceType type;
  final String httpEndpoint;
  final String? locationDescription;
  final int? farmId;

  DeviceCreateBase({
    required this.macId,
    required this.name,
    required this.type,
    required this.httpEndpoint,
    this.locationDescription,
    this.farmId,
  });

  Map<String, dynamic> toJsonBase() => {
        'mac_id': macId,
        'name': name,
        'type': type.toApi(),
        'http_endpoint': httpEndpoint,
        'location_description': locationDescription,
        'farm_id': farmId,
      };
}

class DosingDeviceCreate extends DeviceCreateBase {
  final List<PumpConfig> pumpConfigurations;

  DosingDeviceCreate({
    required String macId,
    required String name,
    required String httpEndpoint,
    String? locationDescription,
    int? farmId,
    required this.pumpConfigurations,
  }) : super(
            macId: macId,
            name: name,
            type: DeviceType.dosingUnit,
            httpEndpoint: httpEndpoint,
            locationDescription: locationDescription,
            farmId: farmId);

  Map<String, dynamic> toJson() => {
        ...toJsonBase(),
        'pump_configurations':
            pumpConfigurations.map((e) => e.toJson()).toList(),
      };
}

class SensorDeviceCreate extends DeviceCreateBase {
  final Map<String, dynamic> sensorParameters;

  SensorDeviceCreate({
    required String macId,
    required String name,
    required DeviceType type,
    required String httpEndpoint,
    String? locationDescription,
    int? farmId,
    required this.sensorParameters,
  }) : super(
            macId: macId,
            name: name,
            type: type,
            httpEndpoint: httpEndpoint,
            locationDescription: locationDescription,
            farmId: farmId);

  Map<String, dynamic> toJson() => {
        ...toJsonBase(),
        'sensor_parameters': sensorParameters,
      };
}

class ValveDeviceCreate extends DeviceCreateBase {
  final List<ValveConfig> valveConfigurations;

  ValveDeviceCreate({
    required String macId,
    required String name,
    required String httpEndpoint,
    String? locationDescription,
    int? farmId,
    required this.valveConfigurations,
  }) : super(
            macId: macId,
            name: name,
            type: DeviceType.valveController,
            httpEndpoint: httpEndpoint,
            locationDescription: locationDescription,
            farmId: farmId);

  Map<String, dynamic> toJson() => {
        ...toJsonBase(),
        'valve_configurations':
            valveConfigurations.map((e) => e.toJson()).toList(),
      };
}

/// ─── DOSING PROFILES & OPERATIONS ────────────────────────────────────────

class DosingProfile {
  final int id;
  final int deviceId;
  final String plantName;
  final String plantType;
  final String growthStage;
  final DateTime seedingDate;
  final double targetPhMin;
  final double targetPhMax;
  final double targetTdsMin;
  final double targetTdsMax;
  final Map<String, dynamic> dosingSchedule;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DosingProfile({
    required this.id,
    required this.deviceId,
    required this.plantName,
    required this.plantType,
    required this.growthStage,
    required this.seedingDate,
    required this.targetPhMin,
    required this.targetPhMax,
    required this.targetTdsMin,
    required this.targetTdsMax,
    required this.dosingSchedule,
    this.createdAt,
    this.updatedAt,
  });

  factory DosingProfile.fromJson(Map<String, dynamic> json) => DosingProfile(
        id: json['id'] as int,
        deviceId: json['device_id'] as int,
        plantName: json['plant_name'] as String,
        plantType: json['plant_type'] as String,
        growthStage: json['growth_stage'] as String,
        seedingDate: DateTime.parse(json['seeding_date'] as String),
        targetPhMin: (json['target_ph_min'] as num).toDouble(),
        targetPhMax: (json['target_ph_max'] as num).toDouble(),
        targetTdsMin: (json['target_tds_min'] as num).toDouble(),
        targetTdsMax: (json['target_tds_max'] as num).toDouble(),
        dosingSchedule: json['dosing_schedule'] as Map<String, dynamic>,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'device_id': deviceId,
        'plant_name': plantName,
        'plant_type': plantType,
        'growth_stage': growthStage,
        'seeding_date': seedingDate.toIso8601String(),
        'target_ph_min': targetPhMin,
        'target_ph_max': targetPhMax,
        'target_tds_min': targetTdsMin,
        'target_tds_max': targetTdsMax,
        'dosing_schedule': dosingSchedule,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}

class DosingProfileCreate {
  final int deviceId;
  final String plantName;
  final String plantType;
  final String growthStage;
  final DateTime seedingDate;
  final double targetPhMin;
  final double targetPhMax;
  final double targetTdsMin;
  final double targetTdsMax;
  final Map<String, dynamic> dosingSchedule;

  DosingProfileCreate({
    required this.deviceId,
    required this.plantName,
    required this.plantType,
    required this.growthStage,
    required this.seedingDate,
    required this.targetPhMin,
    required this.targetPhMax,
    required this.targetTdsMin,
    required this.targetTdsMax,
    required this.dosingSchedule,
  });

  Map<String, dynamic> toJson() => {
        'device_id': deviceId,
        'plant_name': plantName,
        'plant_type': plantType,
        'growth_stage': growthStage,
        'seeding_date': seedingDate.toIso8601String(),
        'target_ph_min': targetPhMin,
        'target_ph_max': targetPhMax,
        'target_tds_min': targetTdsMin,
        'target_tds_max': targetTdsMax,
        'dosing_schedule': dosingSchedule,
      };
}

class DosingAction {
  final int pumpNumber;
  final String chemicalName;
  final double doseMl;
  final String reasoning;

  DosingAction({
    required this.pumpNumber,
    required this.chemicalName,
    required this.doseMl,
    required this.reasoning,
  });

  factory DosingAction.fromJson(Map<String, dynamic> json) => DosingAction(
        pumpNumber: json['pump_number'] as int,
        chemicalName: json['chemical_name'] as String,
        doseMl: (json['dose_ml'] as num).toDouble(),
        reasoning: json['reasoning'] as String,
      );

  Map<String, dynamic> toJson() => {
        'pump_number': pumpNumber,
        'chemical_name': chemicalName,
        'dose_ml': doseMl,
        'reasoning': reasoning,
      };
}

class DosingOperation {
  final int deviceId;
  final String operationId;
  final List<DosingAction> actions;
  final String status;
  final DateTime timestamp;

  DosingOperation({
    required this.deviceId,
    required this.operationId,
    required this.actions,
    required this.status,
    required this.timestamp,
  });

  factory DosingOperation.fromJson(Map<String, dynamic> json) =>
      DosingOperation(
        deviceId: json['device_id'] as int,
        operationId: json['operation_id'] as String,
        actions: (json['actions'] as List)
            .map((e) => DosingAction.fromJson(e))
            .toList(),
        status: json['status'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );

  Map<String, dynamic> toJson() => {
        'device_id': deviceId,
        'operation_id': operationId,
        'actions': actions.map((a) => a.toJson()).toList(),
        'status': status,
        'timestamp': timestamp.toIso8601String(),
      };
}

class SensorReading {
  final int deviceId;
  final String readingType;
  final double value;
  final DateTime timestamp;
  final String? location;

  SensorReading({
    required this.deviceId,
    required this.readingType,
    required this.value,
    required this.timestamp,
    this.location,
  });

  factory SensorReading.fromJson(Map<String, dynamic> json) => SensorReading(
        deviceId: json['device_id'] as int,
        readingType: json['reading_type'] as String,
        value: (json['value'] as num).toDouble(),
        timestamp: DateTime.parse(json['timestamp'] as String),
        location: json['location'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'device_id': deviceId,
        'reading_type': readingType,
        'value': value,
        'timestamp': timestamp.toIso8601String(),
        'location': location,
      };
}

/// ─── SUPPLY CHAIN ────────────────────────────────────────────────────────

class TransportRequest {
  final String origin;
  final String destination;
  final String produceType;
  final double weightKg;
  final String transportMode;

  TransportRequest({
    required this.origin,
    required this.destination,
    required this.produceType,
    required this.weightKg,
    this.transportMode = 'railway',
  });

  Map<String, dynamic> toJson() => {
        'origin': origin,
        'destination': destination,
        'produce_type': produceType,
        'weight_kg': weightKg,
        'transport_mode': transportMode,
      };
}

class SupplyChainAnalysis {
  final String origin;
  final String destination;
  final String produceType;
  final double weightKg;
  final String transportMode;
  final double distanceKm;
  final double costPerKg;
  final double totalCost;
  final double estimatedTimeHours;
  final double marketPricePerKg;
  final double netProfitPerKg;
  final String finalRecommendation;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SupplyChainAnalysis({
    required this.origin,
    required this.destination,
    required this.produceType,
    required this.weightKg,
    required this.transportMode,
    required this.distanceKm,
    required this.costPerKg,
    required this.totalCost,
    required this.estimatedTimeHours,
    required this.marketPricePerKg,
    required this.netProfitPerKg,
    required this.finalRecommendation,
    this.createdAt,
    this.updatedAt,
  });

  factory SupplyChainAnalysis.fromJson(Map<String, dynamic> json) =>
      SupplyChainAnalysis(
        origin: json['origin'] as String,
        destination: json['destination'] as String,
        produceType: json['produce_type'] as String,
        weightKg: (json['weight_kg'] as num).toDouble(),
        transportMode: json['transport_mode'] as String,
        distanceKm: (json['distance_km'] as num).toDouble(),
        costPerKg: (json['cost_per_kg'] as num).toDouble(),
        totalCost: (json['total_cost'] as num).toDouble(),
        estimatedTimeHours: (json['estimated_time_hours'] as num).toDouble(),
        marketPricePerKg: (json['market_price_per_kg'] as num).toDouble(),
        netProfitPerKg: (json['net_profit_per_kg'] as num).toDouble(),
        finalRecommendation: json['final_recommendation'] as String,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'origin': origin,
        'destination': destination,
        'produce_type': produceType,
        'weight_kg': weightKg,
        'transport_mode': transportMode,
        'distance_km': distanceKm,
        'cost_per_kg': costPerKg,
        'total_cost': totalCost,
        'estimated_time_hours': estimatedTimeHours,
        'market_price_per_kg': marketPricePerKg,
        'net_profit_per_kg': netProfitPerKg,
        'final_recommendation': finalRecommendation,
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
        if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
      };
}

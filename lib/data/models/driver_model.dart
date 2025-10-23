import 'package:gas_admin_app/data/models/user_model.dart';

class DriverModel {
  final int driverId;
  final int userId;
  final String fullName;
  final bool blocked;
  final String vehicleType;
  final String licenseNumber;
  final int isAvailable;
  final String? currentLocation;
  final String rating;
  final String? maxCapacity;
  final UserModel user;

  DriverModel({
    required this.driverId,
    required this.userId,
    required this.fullName,
    required this.blocked,
    required this.vehicleType,
    required this.licenseNumber,
    required this.isAvailable,
    this.currentLocation,
    required this.rating,
    this.maxCapacity,
    required this.user,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      driverId: json['driver_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      fullName: json['full_name'] ?? '',
      blocked: ((json['blocked'] == 1 || json['blocked'] == true)
          ? true
          : false),
      vehicleType: json['vehicle_type'] ?? '',
      licenseNumber: json['license_number'] ?? '',
      isAvailable: json['is_available'] ?? 0,
      currentLocation: json['current_location'],
      rating: json['rating'] ?? '0.00',
      maxCapacity: json['max_capacity'],
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }

  DriverModel copyWith({
    int? driverId,
    int? userId,
    String? fullName,
    bool? blocked,
    String? vehicleType,
    String? licenseNumber,
    int? isAvailable,
    String? currentLocation,
    String? rating,
    String? maxCapacity,
    UserModel? user,
  }) {
    return DriverModel(
      driverId: driverId ?? this.driverId,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      blocked: blocked ?? this.blocked,
      vehicleType: vehicleType ?? this.vehicleType,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      isAvailable: isAvailable ?? this.isAvailable,
      currentLocation: currentLocation ?? this.currentLocation,
      rating: rating ?? this.rating,
      maxCapacity: maxCapacity ?? this.maxCapacity,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driver_id': driverId,
      'user_id': userId,
      'full_name': fullName,
      'blocked': blocked,
      'vehicle_type': vehicleType,
      'license_number': licenseNumber,
      'is_available': isAvailable,
      'current_location': currentLocation,
      'rating': rating,
      'max_capacity': maxCapacity,
      'user': user.toJson(),
    };
  }
}

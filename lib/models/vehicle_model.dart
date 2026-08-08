import 'package:equatable/equatable.dart';

/// Registered user vehicle model
class VehicleModel extends Equatable {
  final String id;
  final String registrationNumber;
  final String modelName;
  final String type; // "Car", "SUV", "EV", "Bike"
  final bool isDefault;

  const VehicleModel({
    required this.id,
    required this.registrationNumber,
    required this.modelName,
    required this.type,
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'registrationNumber': registrationNumber,
      'modelName': modelName,
      'type': type,
      'isDefault': isDefault,
    };
  }

  factory VehicleModel.fromMap(Map<String, dynamic> map, String id) {
    return VehicleModel(
      id: id,
      registrationNumber: map['registrationNumber'] ?? 'TN 01 AB 1234',
      modelName: map['modelName'] ?? 'Hyundai Creta',
      type: map['type'] ?? 'SUV',
      isDefault: map['isDefault'] ?? false,
    );
  }

  @override
  List<Object?> get props => [id, registrationNumber, modelName, type, isDefault];
}

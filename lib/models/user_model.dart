import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// User profile data model for SmartPark AI
class UserModel extends Equatable {
  final String uid;
  final String email;
  final String name;
  final String phoneNumber;
  final String avatarUrl;
  final int rewardPoints;
  final double driverScore;
  final double walletBalance;
  final List<String> savedVehicleIds;
  final DateTime createdAt;
  final bool isVerified;
  final bool isGoogleUser;

  const UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.avatarUrl,
    required this.rewardPoints,
    required this.driverScore,
    required this.walletBalance,
    required this.savedVehicleIds,
    required this.createdAt,
    this.isVerified = false,
    this.isGoogleUser = false,
  });

  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? phoneNumber,
    String? avatarUrl,
    int? rewardPoints,
    double? driverScore,
    double? walletBalance,
    List<String>? savedVehicleIds,
    DateTime? createdAt,
    bool? isVerified,
    bool? isGoogleUser,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      driverScore: driverScore ?? this.driverScore,
      walletBalance: walletBalance ?? this.walletBalance,
      savedVehicleIds: savedVehicleIds ?? this.savedVehicleIds,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
      isGoogleUser: isGoogleUser ?? this.isGoogleUser,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
      'rewardPoints': rewardPoints,
      'driverScore': driverScore,
      'walletBalance': walletBalance,
      'savedVehicleIds': savedVehicleIds,
      'createdAt': createdAt.toIso8601String(),
      'isVerified': isVerified,
      'isGoogleUser': isGoogleUser,
    };
  }

  /// Converts to a Firestore map for creation (uses server timestamps)
  Map<String, dynamic> toFirestoreCreateMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
      'rewardPoints': rewardPoints,
      'driverScore': driverScore,
      'walletBalance': walletBalance,
      'savedVehicleIds': savedVehicleIds,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'lastLogin': FieldValue.serverTimestamp(),
      'isVerified': isVerified,
      'isGoogleUser': isGoogleUser,
      'role': 'user',
    };
  }

  /// Converts to a Firestore map for login updates only
  Map<String, dynamic> toFirestoreLoginUpdateMap({
    required bool isVerified,
    String? avatarUrl,
    String? name,
    String? email,
  }) {
    return {
      'lastLogin': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'isVerified': isVerified,
      if (avatarUrl != null && avatarUrl.isNotEmpty) 'avatarUrl': avatarUrl,
      if (name != null && name.isNotEmpty) 'name': name,
      if (email != null && email.isNotEmpty) 'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime createdAt;
    final rawCreatedAt = map['createdAt'];
    if (rawCreatedAt is Timestamp) {
      createdAt = rawCreatedAt.toDate();
    } else if (rawCreatedAt is String) {
      createdAt = DateTime.tryParse(rawCreatedAt) ?? DateTime.now();
    } else {
      createdAt = DateTime.now();
    }

    return UserModel(
      uid: id,
      email: map['email'] ?? '',
      name: map['name'] ?? 'Driver',
      phoneNumber: map['phoneNumber'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
      rewardPoints: (map['rewardPoints'] ?? 0).toInt(),
      driverScore: (map['driverScore'] ?? 4.9).toDouble(),
      walletBalance: (map['walletBalance'] ?? 0.0).toDouble(),
      savedVehicleIds: List<String>.from(map['savedVehicleIds'] ?? []),
      createdAt: createdAt,
      isVerified: map['isVerified'] ?? false,
      isGoogleUser: map['isGoogleUser'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source, String id) =>
      UserModel.fromMap(json.decode(source), id);

  @override
  List<Object?> get props => [
        uid,
        email,
        name,
        phoneNumber,
        avatarUrl,
        rewardPoints,
        driverScore,
        walletBalance,
        savedVehicleIds,
        createdAt,
        isVerified,
        isGoogleUser,
      ];
}

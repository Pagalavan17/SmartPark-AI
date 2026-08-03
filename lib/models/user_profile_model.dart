import 'package:equatable/equatable.dart';

class UserProfileModel extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String phoneNumber;
  final String vehicleNumber;
  final String preferredLanguage;

  const UserProfileModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.vehicleNumber,
    required this.preferredLanguage,
  });

  @override
  List<Object?> get props => [
        uid,
        name,
        email,
        phoneNumber,
        vehicleNumber,
        preferredLanguage,
      ];
}

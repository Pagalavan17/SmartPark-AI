import 'package:equatable/equatable.dart';

/// User feedback and rating review model for a parking facility
class ParkingReviewModel extends Equatable {
  final String id;
  final String parkingId;
  final String userName;
  final String userAvatarUrl;
  final double rating;
  final String date;
  final String comment;
  final String vehicleType;

  const ParkingReviewModel({
    required this.id,
    required this.parkingId,
    required this.userName,
    required this.userAvatarUrl,
    required this.rating,
    required this.date,
    required this.comment,
    required this.vehicleType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'parkingId': parkingId,
      'userName': userName,
      'userAvatarUrl': userAvatarUrl,
      'rating': rating,
      'date': date,
      'comment': comment,
      'vehicleType': vehicleType,
    };
  }

  factory ParkingReviewModel.fromMap(Map<String, dynamic> map, String id) {
    return ParkingReviewModel(
      id: id,
      parkingId: map['parkingId'] ?? '',
      userName: map['userName'] ?? 'Anonymous Driver',
      userAvatarUrl: map['userAvatarUrl'] ?? '',
      rating: (map['rating'] ?? 5.0).toDouble(),
      date: map['date'] ?? 'Recently',
      comment: map['comment'] ?? '',
      vehicleType: map['vehicleType'] ?? 'Car',
    );
  }

  @override
  List<Object?> get props => [
        id,
        parkingId,
        userName,
        userAvatarUrl,
        rating,
        date,
        comment,
        vehicleType,
      ];
}

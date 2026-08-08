import 'dart:convert';
import 'package:equatable/equatable.dart';

/// Push alert notification model for SmartPark AI
class NotificationModel extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String type; // "Reservation", "Expiry", "Adaptive", "Surge", "AI"
  final bool isRead;
  final DateTime timestamp;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.timestamp,
  });

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    String? type,
    bool? isRead,
    DateTime? timestamp,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'type': type,
      'isRead': isRead,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map, String id) {
    return NotificationModel(
      id: id,
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      type: map['type'] ?? 'General',
      isRead: map['isRead'] ?? false,
      timestamp: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source, String id) =>
      NotificationModel.fromMap(json.decode(source), id);

  @override
  List<Object?> get props => [id, userId, title, body, type, isRead, timestamp];
}

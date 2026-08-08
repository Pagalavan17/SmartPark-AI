import 'dart:convert';
import 'package:equatable/equatable.dart';

/// Payment transaction and invoice model for SmartPark AI
class PaymentTransactionModel extends Equatable {
  final String transactionId;
  final String reservationId;
  final String userId;
  final double amount;
  final String currency;
  final String paymentMethod; // "UPI", "Card", "NetBanking", "Wallet"
  final String status; // "Success", "Pending", "Failed"
  final String invoiceUrl;
  final DateTime timestamp;

  const PaymentTransactionModel({
    required this.transactionId,
    required this.reservationId,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.paymentMethod,
    required this.status,
    required this.invoiceUrl,
    required this.timestamp,
  });

  PaymentTransactionModel copyWith({
    String? transactionId,
    String? reservationId,
    String? userId,
    double? amount,
    String? currency,
    String? paymentMethod,
    String? status,
    String? invoiceUrl,
    DateTime? timestamp,
  }) {
    return PaymentTransactionModel(
      transactionId: transactionId ?? this.transactionId,
      reservationId: reservationId ?? this.reservationId,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      invoiceUrl: invoiceUrl ?? this.invoiceUrl,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transactionId': transactionId,
      'reservationId': reservationId,
      'userId': userId,
      'amount': amount,
      'currency': currency,
      'paymentMethod': paymentMethod,
      'status': status,
      'invoiceUrl': invoiceUrl,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory PaymentTransactionModel.fromMap(Map<String, dynamic> map, String id) {
    return PaymentTransactionModel(
      transactionId: id,
      reservationId: map['reservationId'] ?? '',
      userId: map['userId'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      currency: map['currency'] ?? 'INR',
      paymentMethod: map['paymentMethod'] ?? 'UPI',
      status: map['status'] ?? 'Success',
      invoiceUrl: map['invoiceUrl'] ?? '',
      timestamp: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentTransactionModel.fromJson(String source, String id) =>
      PaymentTransactionModel.fromMap(json.decode(source), id);

  @override
  List<Object?> get props => [
        transactionId,
        reservationId,
        userId,
        amount,
        currency,
        paymentMethod,
        status,
        invoiceUrl,
        timestamp,
      ];
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PaymentStatus { initial, processing, success, failed }

final paymentStatusProvider = StateProvider<PaymentStatus>((ref) => PaymentStatus.initial);

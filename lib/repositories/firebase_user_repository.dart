import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'user_repository.dart';

class FirebaseUserRepository implements IUserRepository {
  final FirebaseFirestore? _firestore;

  FirebaseUserRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserModel?> getUserProfile(String uid) async {
    try {
      if (_firestore != null) {
        final doc = await _firestore.collection('users').doc(uid).get();
        if (doc.exists && doc.data() != null) {
          return UserModel.fromMap(doc.data()!, doc.id);
        }
      }
    } catch (_) {}
    return UserModel(
      uid: uid,
      email: 'alex.morgan@smartpark.ai',
      name: 'Alex Morgan',
      phoneNumber: '+91 98765 43210',
      avatarUrl: '',
      rewardPoints: 240,
      driverScore: 4.9,
      walletBalance: 0.0,
      savedVehicleIds: const ['v_1'],
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<void> saveUserProfile(UserModel user) async {
    try {
      if (_firestore != null) {
        await _firestore.collection('users').doc(user.uid).set(user.toMap());
      }
    } catch (_) {}
  }

  @override
  Stream<UserModel?> streamUserProfile(String uid) {
    if (_firestore == null) return Stream.value(null);
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    });
  }
}

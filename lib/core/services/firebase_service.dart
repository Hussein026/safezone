import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/incident_model.dart';
import '../../data/models/user_model.dart';
import '../../data/models/comment_model.dart';
import '../../data/models/notification_model.dart';
import '../constants/app_constants.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Current user
  User? get currentUser => _auth.currentUser;

  // Auth Stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ─── AUTH ───────────────────────────────────────────

  Future<UserModel?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .update(data);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ─── INCIDENTS ──────────────────────────────────────

  Future<String> createIncident(IncidentModel incident) async {
    final doc = await _firestore
        .collection(AppConstants.incidentsCollection)
        .add(incident.toMap());
    return doc.id;
  }

  Future<List<IncidentModel>> getIncidents() async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.incidentsCollection)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();
      return snapshot.docs
          .map((doc) => IncidentModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Stream<List<IncidentModel>> incidentsStream() {
    return _firestore
        .collection(AppConstants.incidentsCollection)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => IncidentModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> updateIncidentStatus(String id, String status) async {
    await _firestore
        .collection(AppConstants.incidentsCollection)
        .doc(id)
        .update({'status': status});
  }

  Future<void> confirmIncident(String id) async {
    await _firestore
        .collection(AppConstants.incidentsCollection)
        .doc(id)
        .update({'confirmations': FieldValue.increment(1)});
  }

  Future<void> flagIncident(String id) async {
    await _firestore
        .collection(AppConstants.incidentsCollection)
        .doc(id)
        .update({'flagged': true});
  }

  // ─── COMMENTS ───────────────────────────────────────

  Future<void> addComment(String incidentId, CommentModel comment) async {
    await _firestore
        .collection(AppConstants.incidentsCollection)
        .doc(incidentId)
        .collection(AppConstants.commentsCollection)
        .add(comment.toMap());
  }

  Stream<List<CommentModel>> commentsStream(String incidentId) {
    return _firestore
        .collection(AppConstants.incidentsCollection)
        .doc(incidentId)
        .collection(AppConstants.commentsCollection)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CommentModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // ─── NOTIFICATIONS ──────────────────────────────────

  Future<void> createNotification(
      String userId, NotificationModel notification) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection(AppConstants.notificationsCollection)
        .add(notification.toMap());
  }

  Stream<List<NotificationModel>> notificationsStream(String userId) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection(AppConstants.notificationsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> markNotificationRead(String userId, String notificationId) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection(AppConstants.notificationsCollection)
        .doc(notificationId)
        .update({'isRead': true});
  }
}